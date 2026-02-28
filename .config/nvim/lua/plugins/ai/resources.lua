local M = {}


M.start_intercept_server = function(port)
    -- Create a short-lived TCP server to intercept CC prompt payload and display it in a new buffer
    local uv = vim.uv or vim.loop
    local server = uv.new_tcp()

    assert(server, "Failed to create TCP server")

    -- Bind to localhost. If port is busy, it will silently fail to avoid conflicts/crashes.
    local success, err = pcall(function() server:bind("127.0.0.1", port) end)
    if not success then return end

    server:listen(128, function(err)
        if err then return end
        local client = uv.new_tcp()

        assert(client, "Failed to create TCP client")

        server:accept(client)

        local request_data = ""
        client:read_start(function(err, chunk)
            if err or not chunk then
                client:close()
                return
            end

            request_data = request_data .. chunk
            local body_start = request_data:find("\r\n\r\n")

            if not body_start then return end

            local headers = request_data:sub(1, body_start - 1)
            local content_length = headers:match("[Cc]ontent%-[Ll]ength:%s*(%d+)")
            local body = request_data:sub(body_start + 4)

            -- check we received the complete JSON payload
            if content_length and #body >= tonumber(content_length) then
                local json_payload = body:sub(1, tonumber(content_length))

                vim.schedule(function()
                    local ok, parsed = pcall(vim.fn.json_decode, json_payload)

                    if not ok then
                        vim.notify("Prompt Intercept: JSON decode failed", vim.log.levels.ERROR)
                        return
                    end

                    if parsed and parsed.messages then
                        local lines = {}
                        for _, msg in ipairs(parsed.messages) do
                            if msg.role == "user" then
                                local content = msg.content
                                if type(content) == "table" then
                                    local parts = {}
                                    for _, part in ipairs(content) do
                                        if part.type == "text" then
                                            table.insert(parts, part.text)
                                        elseif part.type == "image_url" then
                                            table.insert(parts, "[IMAGE: " .. (part.image_url.url or "binary") .. "]")
                                        end
                                    end
                                    content = table.concat(parts, "\n")
                                end

                                content = content or ""
                                -- Cleanup attachment tags and inject filename into code block
                                content = content:gsub("</attachment>", "")
                                content = content:gsub('<attachment filepath="([^"]+)".->.-\n(```%w*)', '%2\n  | # %1')

                                local content_lines = vim.split(content, "\n")
                                for _, line in ipairs(content_lines) do
                                    table.insert(lines, line)
                                end
                                table.insert(lines, "") -- Add a single empty line between user messages for spacing
                            end
                        end
                        
                        -- Remove trailing empty lines
                        while #lines > 0 and lines[#lines] == "" do
                            table.remove(lines)
                        end

                        local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                        vim.bo[buf].filetype = "markdown"
                        
                        local split_ok, split_err = pcall(vim.cmd, "vsplit")
                        if split_ok then
                            vim.api.nvim_win_set_buf(0, buf) -- Set the buffer to the new one
                        else
                            vim.notify("Prompt Intercept: Failed to split window: " .. tostring(split_err), vim.log.levels.ERROR)
                        end
                    else
                        local keys = {}
                        for k, _ in pairs(parsed or {}) do table.insert(keys, k) end
                        vim.notify("Prompt Intercept: Parsed JSON missing 'messages'. Keys found: " .. table.concat(keys, ", "), vim.log.levels.WARN)
                    end
                end)

                local response_body = '{"id": "mock", "object": "chat.completion", "created":0, "model":"prompt-builder", "choices": [{"index":0, "message":{"role":"assistant","content":"✅ Prompt intercepted and copied to split buffer!"}, "finish_reason":"stop"}]}'
                local response = "HTTP/1.1 200 OK \r\nContent-Type: application/json\r\nContent-Length: " .. #response_body .. "\r\nConnection: close\r\n\r\n" .. response_body

                client:write(response, function()
                    client:close()
                    server:close()
                end)
            end
        end)
    end)
end


return M


