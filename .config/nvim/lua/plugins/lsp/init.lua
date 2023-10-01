return {
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.

    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'mason.nvim',
            'mason-lspconfig.nvim',
            'cmp-nvim-lsp',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            local common = require('plugins.lsp.common')

            -- Ensure neodev gets loaded before lsp setup
            -- https://github.com/folke/neodev.nvim/issues/98#issuecomment-1363407235
            require("neodev").setup({
                override = function(rootd, lib)
                    lib.enabled = true
                    lib.plugins = true
                end
            })

            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    local server_conf = common.servers[server_name] or {}
                    require('lspconfig')[server_name].setup {
                        capabilities = common.capabilities,
                        on_attach = server_conf.on_attach or common.on_attach,
                        cmd = server_conf.cmd,
                        settings = server_conf.settings,
                        filetypes = server_conf.filetypes,
                    }
                end
            })

        end
    },

    {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup({
                ui = {
                    border = "single",
                    icons = {
                        package_installed = "",
                        package_pending = "",
                        package_uninstalled = "",
                    },
                },
            })

            require("mason-registry"):on(
                "package:install:success",
                vim.schedule_wrap(require("plugins.lsp.python").install_extras)
            )
        end,
    },

    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            "mason.nvim",
            "cmp-nvim-lsp",
            'nvim-notify',
        },
        config = function()
            local common = require('plugins.lsp.common')

            require("mason-lspconfig").setup({
                -- TODO: add a filter on "ensure_installed" on servers table
                ensure_installed = vim.tbl_keys(common.servers)
            })
        end
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },
}
