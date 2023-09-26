local fmap = {}

fmap.mason_post_install = function(pkg, _)
    -- after updating pylsp automatically install pylsp plugins/extensions
    if pkg.name ~= "python-lsp-server" then
        return
    end

    local venv = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server/venv"
    local job = require("plenary.job")
    local fn = "Mason Post-Install"
    local notify = require("notify")

    ---@diagnostic disable: missing-fields
    job:new({
        command = venv .. "/bin/pip",
        args = {
            "install",
            "-U",
            "--disable-pip-version-check",
            "pylsp-mypy",
            "python-lsp-ruff",
        },
        cwd = venv,
        env = { VIRTUAL_ENV = venv },
        on_start = function()
            notify("Installing pylsp extras...", "info", { title = fn })
        end,
        on_exit = function()
            notify("Finished installing pylsp extras", "info", { title = fn })
        end,
    }):start()
end

return fmap
