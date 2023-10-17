-- NOTE: use of vim.{o,wo} is due to merging kickstart.nvim config here
-- Enable mouse mode
vim.o.mouse = 'a'

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Use hybrid relative line-numbering
vim.opt.nu = true
vim.opt.relativenumber = true

-- Configure indentation behaviour
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.breakindent = true

vim.opt.smartindent = true

-- Configure undo/swap
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.opt.undofile = true

-- Theme / visual configuration
vim.o.hlsearch = false
vim.wo.signcolumn = 'yes'
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true

-- Treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false  -- don't load buffer folded
