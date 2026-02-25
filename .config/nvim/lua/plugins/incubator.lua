-- --------------------------------------------------------------------------
-- Incubator
--
-- A quarantine area for trialling plugins and deciding where they fit.
-- --------------------------------------------------------------------------
return {
    --'Bekaboo/dropbar.nvim', -- not ready yet, needs neovim nightly 0.10.0-dev+

    {
        'topaxi/gh-actions.nvim',
        cmd = 'GhActions',
        keys = {
            { '<leader>gh', '<cmd>GhActions<cr>', desc = 'Open Github Actions' },
        },
        -- optional, you can also install and use `yq` instead.
        build = 'make',
        dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
        opts = {},
        config = function(_, opts)
            require('gh-actions').setup(opts)
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        opts = {
            filesystem = {
                hijack_netrw = false, -- explicitly disable netrw hijack to avoid race condition
            }
        }
    },

    --{
    --    'stevearc/oil.nvim',
    --    opts = {
    --        keymaps = {
    --            -- rebind c-l and c-h (and may as well rebind c-s)
    --            ["<C-s>"] = false,
    --            ["<C-h>"] = false,
    --            ["<C-l>"] = false,
    --            ["<leader>vs"] = "actions.select_vsplit",
    --            ["<leader>hs"] = "actions.select_split",
    --            ["<C-0>"] = "actions.refresh",
    --        },
    --    },
    --    -- Optional dependencies
    --    dependencies = { "nvim-tree/nvim-web-devicons" },
    --},

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    {
        "airblade/vim-rooter",
        config = function()
            vim.api.nvim_set_var("rooter_manual_only", 1)
        end
    },

    'mechatroner/rainbow_csv',


    -- Bug with this on new buffers I cba to track down
    --{
    --    -- This uses beatiful-mermaid to render mermaid diagrams in markdown files.
    --    -- Did need to
    --    -- ```
    --    -- luarocks config --local lua_interpreter luajit
    --    -- luarocks config --local lua_version 5.1
    --    -- sudo apt install imagemagick libmagickwand-dev
    --    -- luarocks install magick
    --    "ruslan-kurchenko/nvim-beautiful-mermaid",
    --    dependencies = { "3rd/image.nvim" },
    --    config = function()
    --        require("image").setup({
    --            backend = "kitty",
    --            editor_only_render_when_focused = true, -- Recommended for tmux
    --            integrations = { markdown = { enabled = false } },
    --        })
    --        require("beautiful_mermaid").setup({
    --            render = { target = "in_buffer", format = "svg", backend = "image" },
    --        })
    --    end,
    --},
}
