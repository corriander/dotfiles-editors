require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "bash", "bibtex", "c_sharp", "comment", "diff", "dockerfile",  "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "html", "htmldjango",  "http", "ini", "java", "javascript", "jq", "json", "jsonc", "latex", "make", "markdown_inline" , "matlab", "passwd", "perl", "python", "regex", "robot", "rst", "ruby", "rust", "scss", "terraform", "tsx", "todotxt", "toml", "turtle", "typescript", "yaml", "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
  },
}
