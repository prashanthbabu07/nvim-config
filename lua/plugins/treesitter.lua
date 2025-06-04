-- https://github.com/nvim-treesitter/nvim-treesitter

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "lua",
                "javascript",
                "c_sharp",
                "typescript",
                "rust",
                "go",
                "html",
                "razor", -- asp.net
                "tsx",   -- For TSX files (TypeScript React)
                -- "jsx",   -- For JSX files (JavaScript React)
                "json",
            },
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
        })
    end,
}

-- return {}
