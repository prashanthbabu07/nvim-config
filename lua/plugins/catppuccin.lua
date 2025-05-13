-- https://github.com/catppuccin/nvim

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local catppuccin = require("catppuccin")
        local cp = require("catppuccin.palettes").get_palette()

        catppuccin.setup({
            flavour = "latte", -- latte, frappe, macchiato, mocha
            color_overrides = {
                all = {
                    -- text = "#1c1c1c",
                },
                latte = {
                    -- base = "#f0f6fc",
                },
            },
            custom_highlights = function(colors)
                return {}
            end,
            highlight_overrides = {
                all = function(colors)
                    return {}
                end,
                latte = function(latte)
                    return {}
                end,
            },
        })
        -- vim.cmd("colorscheme catppuccin")
        vim.cmd.colorscheme("catppuccin")

        vim.api.nvim_set_hl(0, "DapStoppedLine", {
            bg = cp.yellow, -- a bright pinkish highlight from Catppuccin Latte
            -- fg = "#000000", -- black text for contrast (optional)
            underline = false,
        })

        vim.api.nvim_set_hl(0, "DapStopped", {
            fg = cp.red,
            bg = cp.yellow,
        })

        vim.fn.sign_define("DapStopped", {
            text = "→",
            texthl = "DapStopped",
            linehl = "DapStoppedLine",
            numhl = "DapStoppedLine",
        })
    end,
}
