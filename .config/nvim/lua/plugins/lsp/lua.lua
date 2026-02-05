----

return {
    -- we let lazydev.nvim handle most of the configuration, we just want to avoid
    -- premature diagnostics whilst the workspace is still loading via on_attach
    -- If we don't do this, Undefined global warnings spam will appear until edit
    on_attach = function(client, buffer)
        local original_handler = client.handlers["textDocument/publishDiagnostics"]
           or vim.lsp.handlers["textDocument/publishDiagnostics"]

        local attach_ms = vim.loop.now()
        local window_ms = 600

        client.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)

            -- Don't touch other buffers
            local uri = result and result.uri
            local buf = uri and vim.uri_to_bufnr(uri)
            if buf ~= buffer then
                return original_handler(err, result, ctx, config)
            end

            local age = vim.loop.now() - attach_ms

            if age < window_ms and result and result.diagnostics then
                -- if we're still within the window_ms, we dump the undef diagnostics
                local filtered = {}
                for _, diag in ipairs(result.diagnostics) do
                    local msg = diag.message or ""
                    local code = diag.code
                    local is_undef = (code == "undefined-global")
                        or msg:find("Undefined global", 1, true) ~= nil
                    if not is_undef then
                        table.insert(filtered, diag)
                    end
                end
                local new = vim.tbl_extend("force", result, { diagnostics = filtered })
                return original_handler(err, new, ctx, config)
            else
                -- outside the window_ms, we process normally
                client.handlers["textDocument/publishDiagnostics"] = original_handler
                return original_handler(err, result, ctx, config)
            end
        end
    end
}
