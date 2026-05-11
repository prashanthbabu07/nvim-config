-- https://github.com/nvim-treesitter/nvim-treesitter

return {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
        require("tree-sitter-manager").setup({
            -- Default Options
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
                "c",
                "python",
            }, -- list of parsers to install at the start of a neovim session
            -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
            -- auto_install = false, -- if enabled, install missing parsers when editing a new file
            -- highlight = true, -- treesitter highlighting is enabled by default
            -- languages = {}, -- override or add new parser sources
            -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
            -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
        })
    end,
}

-- return {
--     "nvim-treesitter/nvim-treesitter",
--     branch = "main", -- Ensure you are on main, not master
--     build = ":TSUpdate",
--     config = function()
--         -- IMPORTANT: require('nvim-treesitter.configs') NO LONGER EXISTS
--         -- The new way is to use the direct setup or just let native 0.12 handle it.
--         require("nvim-treesitter").setup({
--             -- your usual config here
--             ensure_installed = {
--                 "c_sharp",
--                 "lua",
--                 "vim",
--                 "vimdoc",
--                 "query",
--                 "go",
--                 "rust",
--                 "html",
--                 "razor",
--                 "tsx",
--                 "json",
--             },
--             highlight = { enable = true },
--         })
--     end,
-- }

-- return {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     config = function()
--         local config = require("nvim-treesitter.configs")
--         config.setup({
--             ensure_installed = {
--                 "lua",
--                 "javascript",
--                 "c_sharp",
--                 "typescript",
--                 "rust",
--                 "go",
--                 "html",
--                 "razor", -- asp.net
--                 "tsx",   -- For TSX files (TypeScript React)
--                 -- "jsx",   -- For JSX files (JavaScript React)
--                 "json",
--             },
--             modules = {},         -- required for type checker
--             sync_install = false, -- required for type checker
--             ignore_install = {},  -- required for type checker
--             auto_install = true,
--             highlight = { enable = true, additional_vim_regex_highlighting = false },
--             indent = {
--                 enable = true,
--                 disable = { "lua" },
--             },
--         })
--     end,
-- }

-- return {}
