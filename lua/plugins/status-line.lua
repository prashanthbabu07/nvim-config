-- https://github.com/nvim-lualine/lualine.nvim

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local auto_theme_custom = require("lualine.themes.auto")
        auto_theme_custom.normal.c.bg = "None" -- Or ''
        require("lualine").setup({
            options = {
                theme = auto_theme_custom,
            },
        })
        -- require("lualine").setup({
        --     options = {
        --         -- theme = "dracula",
        --         theme = "auto",
        --     },
        -- })
    end,
}
