-- ----------------------------------------------------------------------------
-- Navigation / orientation configuration
-- ----------------------------------------------------------------------------

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function ()
        local fb_actions = require("telescope").extensions.file_browser.actions
        local actions = require("telescope.actions")

        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
          pickers = {
              live_grep = {
              additional_args = function(opts)
                      return {"--hidden"}
                  end
              },
          },
          defaults = {
            file_ignore_patterns = { ".git/" },
            mappings = {
              i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
              },
            },
          },
          extensions = {
              file_browser = {
                  --theme = "ivy",
                  -- disables netrw and use telescope-file-browser in its place
                  hidden = true,
                  respect_gitignore = true,
                  hijack_netrw = true,
                  follow_symlinks = true,
                  mappings = {
                      ["i"] = {
                          -- your custom insert mode mappings
                          ["-/"] = fb_actions.goto_parent_dir,  -- when prompt is empty
                      },
                      ["n"] = {
                          -- your custom normal mode mappings
                          ["-"] = fb_actions.goto_parent_dir,
                          -- ease transition between modes
                          ["<C-p>"] = actions.move_selection_previous,
                          ["<C-n>"] = actions.move_selection_next,
                      },
                  },
              },
          },
        }

        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')

        -- Enable telescope-file-browser, if installed
        pcall(require("telescope").load_extension, "file_browser")

        -- See `:help telescope.builtin`
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>sf', function()
            builtin.find_files({ hidden = true, follow = true })
          end,
        { desc = '[S]earch [F]iles' }
        )
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]resume' })
        vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld Files' })

        vim.keymap.set('n', '<leader>pf', function()
          builtin.find_files({
            hidden = true,
            follow = true,
            cwd = vim.api.nvim_call_function("FindRootDirectory", {}),
            --cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          })
        end)
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
        	builtin.grep_string({ search = vim.fn.input("Grep > ") });
        end)
    end
  },

}
