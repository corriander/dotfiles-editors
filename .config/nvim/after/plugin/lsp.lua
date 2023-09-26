local mason = require('mason')
local lspconfig = require('lspconfig')

-- ----------------------------------------------------------------------------
-- Configure LSP Mappings
-- ----------------------------------------------------------------------------
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
  -- TODO: this is a duplicate of a mapping in nvim-cmp setup (<leader>e)
  nmap('<leader>h', vim.diagnostic.open_float, 'Hover Diagnostic')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- ----------------------------------------------------------------------------
-- Configure Servers
-- ----------------------------------------------------------------------------
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- ----------------------------------------------------------------------------
-- Configure neovim lua
-- TODO: try moving this down; currently preserving order in kickstart.nvim
-- ----------------------------------------------------------------------------
require('neodev').setup()


-- ----------------------------------------------------------------------------
-- Configure Mason
-- ----------------------------------------------------------------------------

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- ----------------------------------------------------------------------------
-- Configure diagnostic signs
-- ----------------------------------------------------------------------------
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ----------------------------------------------------------------------------
-- Configure Python LSP
-- ----------------------------------------------------------------------------
lspconfig.pylsp.setup({
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
})

-- ----------------------------------------------------------------------------
-- Selectively disable hints from pyright
-- ----------------------------------------------------------------------------
-- This all works, tested against pyright for a specific "not accessed" hint and it suppresses it
-- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1075539112
--function filter(arr, func)
--	-- Filter in place
--	-- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
--	local new_index = 1
--	local size_orig = #arr
--	for old_index, v in ipairs(arr) do
--		if func(v, old_index) then
--			arr[new_index] = v
--			new_index = new_index + 1
--		end
--	end
--	for i = new_index, size_orig do arr[i] = nil end
--end
--
--
--function filter_diagnostics(diagnostic)
--	-- Allow kwargs to be unused, sometimes you want many functions to take the
--	-- same arguments but you don't use all the arguments in all the functions,
--	-- so kwargs is used to suck up all the extras
--	--if diagnostic.message == '"kwargs" is not accessed' then
--	--	return false
--	--end
--
--	---- Allow variables starting with an underscore
--	--if string.match(diagnostic.message, '"_.+" is not accessed') then
--	--	return false
--	--end
--
--	if string.match(diagnostic.message, '"exc_info" is not accessed') then
--		return false
--	end
--
--	return true
--end

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
