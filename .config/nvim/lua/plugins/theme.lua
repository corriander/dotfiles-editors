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

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

}
