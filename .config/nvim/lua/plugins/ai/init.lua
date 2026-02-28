return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {

            display = {
                chat = {
                    window = { position = "right", width = 0.3 },
                },
            },

            interactions = {
                chat = {
                    adapter = "koboldcpp", -- HTTP preset; temporary
                    --adapter = "gemini_cli", -- ACP preset
                    variables = {
                        buffer = { opts = { default_params = "diff" } },
                    },
                },
                inline = {
                    adapter = "koboldcpp",
                },
                cmd = {
                    adapter = "gemini_cli", -- ACP preset
                },
            },

            memory = {
                opts = {
                    chat = {
                        enabled = true,
                    },
                },
            },

            adapters = {
                -- Hide ACP presets; keep only the listed adapters visible
                acp = {
                    opts = { show_presets = false },
                    -- Even if we didn't override, we'd still need to specify this
                    -- because the preset hiding will wipe out anything we don't
                    -- define.
                    --gemini_cli = "gemini_cli",  -- Even if we didn't override, we'd still need to

                    gemini_cli = function()
                        return require("codecompanion.adapters").extend("gemini_cli", {
                            commands = {
                                -- Set whichever you want as the default
                                default       = { "gemini", "--experimental-acp" },
                                yolo          = { "gemini", "--experimental-acp", "--yolo" },

                                g3_pro        = { "gemini", "--experimental-acp", "--model=gemini-3-pro-preview" },
                                g3_flash      = { "gemini", "--experimental-acp", "--model=gemini-3-flash-preview" },
                                g3_flash_yolo = { "gemini", "--experimental-acp", "--model=gemini-3-flash-preview",
                                    "--yolo" },
                                g3_pro_yolo   = { "gemini", "--experimental-acp", "--model=gemini-3-pro-preview",
                                    "--yolo" },

                                g2_pro        = { "gemini", "--experimental-acp", "--model=gemini-2.5-pro" },
                                g2_pro_yolo   = { "gemini", "--experimental-acp", "--model=gemini-2.5-pro", "--yolo" },
                                g2_flash      = { "gemini", "--experimental-acp", "--model=gemini-2.5-flash" },
                                g2_flash_yolo = { "gemini", "--experimental-acp", "--model=gemini-2.5-flash", "--yolo" },
                                g2_lite       = { "gemini", "--experimental-acp", "--model=gemini-2.5-flash-lite" },
                            },
                        })
                    end,
                },

                -- Hide HTTP presets; keep only your own adapters visible
                http = {
                    opts = { show_presets = false },

                    koboldcpp = function()
                        local base_url = vim.env.KOBOLD_BASE_URL
                        if not base_url or base_url == "" then
                            error("KOBOLD_BASE_URL is not set (expected e.g. http://localhost:5001)")
                        end

                        -- Ensure we're using the real base URL
                        base_url = base_url:gsub("/v1/?", "")
                        local chat_url = base_url .. "/v1/chat/completions"

                        return require("codecompanion.adapters").extend("openai", {
                            name = "koboldcpp",
                            url = chat_url,
                            formatted_name = "KoboldCPP/OpenAI",
                            env = {
                                api_key = "TERM", -- dummy
                            },
                            schema = {
                                model = {
                                    -- CodeCompanion expects this, but
                                    --   - we only serve 1 model
                                    --   - it's annoying to specify full GGUF names
                                    --   - it's not used by our server ANYWAY
                                    --   - if it ever is important, we get it from v1/models and cache it
                                    default = "koboldcpp/default",
                                },
                                max_tokens = { default = 4096 },
                                temperature = { default = 1.0 },
                                top_p = { default = 0.95 },
                            },
                        })
                    end,

                    proompter = function()
                        local adapter = require("codecompanion.adapters").extend("openai", {
                            name = "proompter",
                            url = "http://localhost:43210",
                            formatted_name = "Prompt Builder (OpenAI)",
                            env = { api_key = "TERM" }, -- dummy
                            schema = {
                                model = {
                                    default = "prompt-builder",
                                    choices = { "prompt-builder" },
                                },
                            },
                        })

                        local original_form_messages = adapter.handlers.form_messages
                        adapter.handlers.form_messages = function(self, messages)
                            require("plugins.ai.resources").start_intercept_server(43210)
                            if original_form_messages then
                                return original_form_messages(self, messages)
                            end
                            return { messages = messages }
                        end

                        return adapter
                    end,
                },
            },

            -- NOTE: Yes, this is in opts.opts
            opts = {
                log_level = "DEBUG", -- or "TRACE"
            },
        },
    },
}
