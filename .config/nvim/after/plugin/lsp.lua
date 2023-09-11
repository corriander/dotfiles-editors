local lsp = require('lsp-zero')
local mason = require('mason')

-- Configure mason
mason.setup({
    ui = {
        border = "single",
    }
})


lsp.preset({
    name = "recommended"
})

-- lsp.ensure_installed({
--     -- python lsp etc.
-- })

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-;>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
    mapping = cmp_mappings
})



lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
  -- TODO: Consider custom bindings. See ThePrimeagen and/or :help
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
