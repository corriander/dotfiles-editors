local mason = require('mason')
local lspconfig = require('lspconfig')

-- Configure mason
mason.setup({
    ui = {
        border = "single",
    }
})


lspconfig.pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pyflakes = {
                    enabled = false
                }
            }
        }
    }
})

-- ----------------------------------------------------------------------------
-- Selectively disable hints from pyright
-- ----------------------------------------------------------------------------
-- This all works, tested against pyright for a specific "not accessed" hint and it suppresses it
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1075539112
function filter(arr, func)
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


function filter_diagnostics(diagnostic)
	-- Allow kwargs to be unused, sometimes you want many functions to take the
	-- same arguments but you don't use all the arguments in all the functions,
	-- so kwargs is used to suck up all the extras
	if diagnostic.message == '"kwargs" is not accessed' then
		return false
	end

	-- Allow variables starting with an underscore
	if string.match(diagnostic.message, '"_.+" is not accessed') then
		return false
	end

	if string.match(diagnostic.message, '"exc_info" is not accessed') then
		return false
	end

	return true
end

--lspconfig.pyright.setup({
--    on_attach = function(client, buffer)
--        client.handlers["textDocument/publishDiagnostics"] = function (a, params, client_id, c, config)
--        	filter(params.diagnostics, filter_diagnostics)
--        	vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
--        end
--        on_attach(client, buffer)
--    end,
--})


-- ----------------------------------------------------------------------------
-- Disable all hints from pyright
-- ----------------------------------------------------------------------------
-- Suppress all hints from pyright by changing the capabilities we advertise
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1439132189
-- Note this can be implemented differently after moving to lazy: 
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1700845901
--lsp.configure('pyright', {
--    capabilities = {
--        textDocument = {
--            publishDiagnostics = {
--                tagSupport = {
--                    valueSet = { 2 }
--                }
--            }
--        }
--    }
--})
