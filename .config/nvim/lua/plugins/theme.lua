-- ----------------------------------------------------------------------------
-- Theme
--
-- Structural and visual configuration of the UI.
-- ----------------------------------------------------------------------------
return {
    'rebelot/kanagawa.nvim',
    'ellisonleao/gruvbox.nvim',
    'navarasu/onedark.nvim',
    { 'rose-pine/neovim', name = 'rose-pine' },
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        opts = {
            transparent_mode = true,
        },
        -- XXX: Problems passing opts, and setting the scheme in config simultaneously.
        --      This may provide a strategy for that elsewhere.
        --          https://github.com/LunarVim/breadcrumbs.nvim/blob/1033b35/README.md
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = 'gruvbox_dark',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        newfile_status = true,
                        path = 4,
                        -- TODO: fmt can maybe add more sophisticated starship-style path handling
                        --       https://github.com/nvim-lualine/lualine.nvim/issues/969#issuecomment-1435911393
                        -- TODO: consider using symbols (padlock, etc.)
                    }
                }
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },

    -- TODO: This is not theme, move it out to appropriate module when ready
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

}
