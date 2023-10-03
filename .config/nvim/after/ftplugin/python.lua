local poetry = os.getenv("HOME") .. "/.local/bin/poetry"  -- XXX: may vary

local group = vim.api.nvim_create_augroup("CustomPythonEvents", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "**/diagrams/*.py",  -- XXX: may vary
    callback = function()
        local job = require("plenary.job")
        local notify = require("notify")

        local afile = vim.fn.expand("<afile>")
        local amatch = vim.fn.expand("<amatch>")

        local stderr_tbl = {}
        local stderr_i = 0
        local notification_title = "Autocommand: Compile python diagram on save"

        local get_key = function(i)
            return string.format("L%03d", i)
        end

        ---@diagnostic disable-next-line: missing-fields
        job:new({
            command = poetry,
            args = {
                "run",
                "compile",
                amatch,
            },
            on_stderr = function(_, stderr)
                stderr_i = stderr_i + 1
                stderr_tbl[get_key(stderr_i)] = stderr
            end,
            on_exit = function(_, return_val)
                local last_line = stderr_tbl[get_key(stderr_i-1)]
                if (return_val > 0 or string.find(last_line, 'ERROR')) then
                    local setf_lua = function(win)
                        local buf = vim.api.nvim_win_get_buf(win)
                        vim.api.nvim_buf_set_option(buf, "filetype", "lua")
                    end

                    notify(
                        vim.inspect(stderr_tbl),
                        "error",
                        { title = notification_title, timeout = false, on_open = setf_lua }
                    )
                else
                    notify(
                        string.format("Compilation successful:\n\n%s", last_line),
                        "info",
                        { title = notification_title, timeout = 1000 }
                    )
                end
            end,
        }):start()
    end,
    group = group,
})
