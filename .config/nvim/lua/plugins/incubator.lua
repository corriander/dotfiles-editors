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
        }
    },

    {
        'stevearc/oil.nvim',
        opts = {
            keymaps = {
                -- rebind c-l and c-h (and may as well rebind c-s)
                ["<C-s>"] = false,
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<leader>vs"] = "actions.select_vsplit",
                ["<leader>hs"] = "actions.select_split",
                ["<C-0>"] = "actions.refresh",
            },
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
