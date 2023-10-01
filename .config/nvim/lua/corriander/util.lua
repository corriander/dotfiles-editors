local M = {}


M.inspect = function(obj)
    local notify_opts = {
        title = "Inspect object",
        timeout = false,
        on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, "filetype", "lua")
		end
    }
    require('notify')(
        vim.inspect(obj),
        "info",
        notify_opts
    )
end


return M

