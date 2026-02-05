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
        },
        config = function()
            -- ----------------------------------------------------------------------------
            -- Configure diagnostic signs
            -- ----------------------------------------------------------------------------
            -- This is the new way to configure diagnostics in Neovim 0.10+
            -- Replaces the legacy sign_define() API but means it has to move out of config
            -- into here so it can be run after the LSP is loaded.
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
                underline = true,
                virtual_text = {
                    spacing = 4,
                    prefix = '', -- Could be '●', '▎', 'x'
                },
                update_in_insert = false,
                severity_sort = true,
            })

            local common = require('plugins.lsp.common')

            local function compose_on_attach(f_orig, f_common, f_server)
                -- provides a callable to compose on_attach functions
                -- most of the config table will be merged, but functions are not
                -- This allows us to avoid clobbering or force chaining inside
                return function(client, bufnr)
                    if f_orig then f_orig(client, bufnr) end
                    f_common(client, bufnr)
                    if f_server then f_server(client, bufnr) end
                end
            end


            -- Replaces legacy setup_handlers() API ( f(server_name) -> lspconfig[server_name].setup() )
            -- with new API
            local servers = vim.tbl_keys(common.servers)
            for _, server_name in ipairs(servers) do
                local server_conf = vim.deepcopy(common.servers[server_name] or {})

                local composed_on_attach = compose_on_attach(
                    (vim.lsp.config[server_name] or {}).on_attach,
                    common.on_attach,
                    server_conf.on_attach
                )

                ---- resolve on_attach by composing them; most settings are merged functions aren't
                --local orig_on_attach = (vim.lsp.config[server_name] or {}).on_attach
                --local common_on_attach = common.on_attach
                --local server_on_attach = server_conf.on_attach
                --local composed_on_attach = function(client, bufnr)
                --    if orig_on_attach then orig_on_attach(client, bufnr) end
                --    common_on_attach(client, bufnr)
                --    if server_on_attach then server_on_attach(client, bufnr) end
                --end
                --

                server_conf.on_attach = composed_on_attach

                local base = { capabilities = common.capabilities }

                local merged_conf = vim.tbl_deep_extend(
                    'force',
                    base,
                    server_conf
                )

                vim.lsp.config(server_name, merged_conf)

                --vim.lsp.config(server_name, {
                --    capabilities = common.capabilities,
                --    on_attach = composed_on_attach,
                --    cmd = server_conf.cmd,
                --    settings = server_conf.settings,
                --    filetypes = server_conf.filetypes,
                --})
            end
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
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require('luasnip.loaders.from_vscode').lazy_load()
            --require('luasnip.loaders.from_vscode').lazy_load({ paths = { './snippets' } })
            require('luasnip.loaders.from_snipmate').lazy_load({ paths = { './snippets' } })
            luasnip.config.setup {}

            ---@diagnostic disable-next-line: missing-fields
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            })
        end,
    },

    {
        'github/copilot.vim',
        enabled = false,
        config = function()
            vim.g.copilot_assume_mapped = true
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                accept = false,
            },
            copilot_node_command = os.getenv('MY_NODE_DEFAULT'),
            filetypes = {
                yaml = true,
                json = false,
                markdown = false,
                txt = false,
            }
        },
        config = function(_, opts)
            require("copilot").setup(opts)

            vim.keymap.set("i", '<Tab>', function()
                if require('copilot.suggestion').is_visible() then
                    require('copilot.suggestion').accept()
                else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
                end
            end, { silent = true })
        end,
    },

    {
        'codota/tabnine-nvim',
        enabled = false,
        build = "./dl_binaries.sh",
        opts = {
            disable_auto_comment = true,
            accept_keymap = "<Tab>",
            dismiss_keymap = "<C-]>",
            debounce_ms = 800,
            suggestion_color = { gui = "#808080", cterm = 244 },
            exclude_filetypes = { "TelescopePrompt", "neo-tree", "oil" },
            log_file_path = vim.fn.stdpath('cache') .. "/tabnine.log", -- absolute path to Tabnine log file
        },
        config = function(_, opts)
            require('tabnine').setup(opts)
        end,
    },

    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            interactions = {
                chat = {
                    adapter = "gemini_cli", -- ACP preset
                    variables = {
                        buffer = { opts = { default_params = "diff" } },
                    },
                },
                inline = {
                    adapter = "kobold_wsl",
                },
            },

            display = {
                chat = {
                    window = { position = "right", width = 0.3 },
                },
            },

            adapters = {
                -- Hide ACP presets; keep only the listed adapters visible
                acp = {
                    opts = { show_presets = false },
                    gemini_cli = "gemini_cli",  -- If we don't re-defined this it will not be available
                },

                -- Hide HTTP presets; keep only your own adapters visible
                http = {
                    opts = { show_presets = false },

                    kobold_wsl = function()
                        local url = vim.env.KOBOLD_BASE_URL
                        if not url or url == "" then
                            error("KOBOLD_BASE_URL is not set (expected e.g. http://localhost:5001)")
                        end

                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                url = url,
                                api_key = "TERM", -- dummy
                                chat_url = "/v1/chat/completions",
                            },
                            schema = {
                                model = {
                                    default = "koboldcpp/mistralai_Devstral-Small-2-24B-Instruct-2512-Q5_K_M",
                                },
                                max_tokens = { default = 2048 },
                                temperature = { default = 0.3 },
                            },
                        })
                    end,
                },
            },
        },
    },

    'psf/black',

    {
        -- replaces neodev
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
        },
        ft = "python",                                                                                         -- Load when opening Python files
        keys = {
            { "<leader>v", "<cmd>VenvSelect<cr>" },                                                            -- Open picker on keymap
        },
        opts = {                                                                                               -- this can be an empty lua table - just showing below for clarity.
            search = {},                                                                                       -- if you add your own searches, they go here.
            options = {}                                                                                       -- if you add plugin options, they go here.
        },
    },
}
