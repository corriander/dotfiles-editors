local M = {}


M.pylsp_opts = {
    cmd = { "pylsp", "--check-parent-process" }, -- close server if process killed
    settings = {
        pylsp = {
            configurationSources = {}, -- not using flake8 or pycodestyle
            plugins = {
                -- disable everything not being used
                autopep8 = { enabled = false },
                isort = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                yapf = { enabled = false },
                -- TODO: Configure python-lsp-ruff
                -- ruff_config() is a WIP
                -- ruff = require("plugins.lsp.python").ruff_config()
                -- TODO: Configure pylsp-mypy for type checking
                -- TODO: Configure python-lsp-black for formatting
                -- TODO: COnsider pyls-memestra for catching deprecations
                -- TODO: Configure Jedi for completion and Rope for refactoring

            }
        }
    }
}

-- ----------------------------------------------------------------------------
-- Selectively disable hints from pyright
-- ----------------------------------------------------------------------------
-- This all works, tested against pyright for a specific "not accessed" hint and it suppresses it
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1075539112
local function filter(arr, func)
	-- Filter in place
	-- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
	local new_index = 1
	local size_orig = #arr
	for old_index, v in ipairs(arr) do
		if func(v, old_index) then
			arr[new_index] = v
			new_index = new_index + 1
		end
	end
	for i = new_index, size_orig do arr[i] = nil end
end


local function filter_diagnostics(diagnostic)
	-- Allow kwargs to be unused, sometimes you want many functions to take the
	-- same arguments but you don't use all the arguments in all the functions,
	-- so kwargs is used to suck up all the extras
	--if diagnostic.message == '"kwargs" is not accessed' then
	--	return false
	--end

	---- Allow variables starting with an underscore
	--if string.match(diagnostic.message, '"_.+" is not accessed') then
	--	return false
	--end

	if string.match(diagnostic.message, '"exc_info" is not accessed') then
		return false
	end

	return true
end

-- Suppress all hints from pyright by changing the capabilities we advertise
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1439132189
-- Note this can be implemented differently after moving to lazy:
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1700845901
M.pyright_opts = {
    capabilities = {
        textDocument = {
            publishDiagnostics = {
                tagSupport = {
                    valueSet = { 2 }
                }
            }
        }
    },
    on_attach = function(client, buffer)
        client.handlers["textDocument/publishDiagnostics"] = function (a, params, client_id, c, config)
            filter(params.diagnostics, filter_diagnostics)
            vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
        end
        require("plugins.lsp.common").on_attach(client, buffer)
    end,
}


M.install_extras = function(pkg, _)
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

return M
