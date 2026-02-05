-- Project commands
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--vim.keymap.set("n", "<leader>pv", "<cmd>Oil<cr>", { desc = "Open parent directory" })
--vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "-", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
	{ noremap = true, desc = "Open current directory" })
vim.keymap.set("n", "<leader>-", "<cmd>Neotree toggle current reveal_force_cwd left<cr>")
vim.keymap.set("n", "<leader>_", "<cmd>Neotree float focus buffers toggle<cr>")
vim.keymap.set("n", "<leader>gS", "<cmd>Neotree float git_status toggle<cr>")

-- Text manipulation
--
-- Move visual blocks about
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Respect og cursor pos for joining lines and semi-page jumps
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Respect original copy buffer when pasting over something
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")

-- Delete to void register (keep prev. text)
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
--
-- Additional Esc shortcut (note Alt/Cmd-[ is valid)
vim.keymap.set("i", "<Alt-k>", "<Esc>")

-- Additional Write shortcut
vim.keymap.set("n", "<leader>w", ":w<CR>")
--
-- :Format shortcut
vim.keymap.set(
	"n",
	"<leader>ff",
	function() vim.lsp.buf.format() end,
	{ desc = "Format current buffer with LSP" }
)

-- Misc
vim.keymap.set("n", "<leader>nu", function()
	vim.api.nvim_command('set invrelativenumber')
end)

vim.keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
  silent = true,
  desc = "open init.lua",
})
