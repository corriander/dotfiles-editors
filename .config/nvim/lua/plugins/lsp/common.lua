local M = {}

---- ----------------------------------------------------------------------------
---- Configure LSP Mappings
---- ----------------------------------------------------------------------------
----  This function gets run when an LSP connects to a particular buffer.
M.on_attach = function(_, bufnr)
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

    vim.api.nvim_buf_create_user_command(
        bufnr,
        'InspectLsp',
        function(_)
            require('corriander.util').inspect(vim.lsp.get_active_clients())
        end,
        { desc = 'Get the current LSP configuration' }
    )
end
--
---- ----------------------------------------------------------------------------
---- Mason: Configure Servers
---- ----------------------------------------------------------------------------
---- Enable the following language servers
----  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
----
----  Add any additional override configuration in the following tables. They will be passed to
----  the `settings` field of the server config. You must look up that documentation yourself.
----
----  If you want to override the default filetypes that your language server will attach to you can
----  define the property 'filetypes' to the map in question.
M.servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    pylsp = require('plugins.lsp.python').pylsp_opts,

    lua_ls = require('plugins.lsp.lua')
}

--
---- ----------------------------------------------------------------------------
---- Configure Capabilities
---- ----------------------------------------------------------------------------
M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--
--
---- ----------------------------------------------------------------------------
---- Configure neovim lua
---- TODO: try moving this; currently preserving order in kickstart.nvim
---- ----------------------------------------------------------------------------
--require('neodev').setup()
--
--
--return {
--  servers = servers,
--  capabilities = capabilities,
--}


return M
