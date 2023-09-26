return {
    {
        -- Used for some of my custom configuration for fancy notifications
        'rcarriga/nvim-notify',
        opts = { background_colour = '#000000' },
        config = true,
    },
    { import = "corriander.lazy" },
    { import = "plugins.nav" },
}
