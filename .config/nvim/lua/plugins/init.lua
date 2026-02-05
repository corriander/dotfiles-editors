return {
    {
        -- Used for some of my custom configuration for fancy notifications
        'rcarriga/nvim-notify',
        opts = { background_colour = '#000000' },
        config = true,
    },

    {
        "ravsii/tree-sitter-d2",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        version = "*", -- use the latest git tag instead of main
        build = "make nvim-install",
    },

    { import = "corriander.lazy" },
    { import = "plugins.nav" },
}
