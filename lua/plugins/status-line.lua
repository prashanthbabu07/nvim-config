-- https://github.com/nvim-lualine/lualine.nvim

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local auto_theme = require("lualine.themes.auto")

        local modes = { "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }
        for _, mode in ipairs(modes) do
            auto_theme[mode].c.bg = "None" -- Or ''
        end
        require("lualine").setup({
            options = {
                theme = auto_theme,
            },
        })
        -- require("lualine").setup({
        --     options = {
        --         theme = "dracula",
        --         -- theme = "auto",
        --     },
        -- })
        vim.o.laststatus = 3
    end,
}
