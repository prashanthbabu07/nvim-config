local function get_macos_theme()
    if vim.fn.has("mac") == 0 then
        -- Not on macOS, so we can't determine the macOS theme
        return "unknown"
    end

    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not handle then
        return "unknown"
    end

    local result = handle:read("*a")
    handle:close()

    if result:match("Dark") then
        return "dark"
    else
        -- If AppleInterfaceStyle is not set or anything else, it's typically light
        return "light"
    end
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            local catppuccin = require("catppuccin")
            -- local cp = require("catppuccin.palettes").get_palette()

            catppuccin.setup({
                flavour = "latte", -- latte, frappe, macchiato, mocha
                no_italic = false,
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
            -- vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("github-theme").setup({
                -- ...
                options = {
                    styles = {
                        comments = "italic",
                    },
                },
                -- palettes = {
                --     github_light_high_contrast = {
                --         bg1 = "#fefefe",
                --     },
                -- },
                groups = {
                    github_light_high_contrast = {
                        Normal = { bg = "#fefefe" },
                        NormalNC = { bg = "#fefefe" },
                        NeoTreeNormal = { bg = "#fefefe" },
                        NeoTreeNormalNC = { bg = "#fefefe" },
                    },
                },
            })

            local theme = "github_light_high_contrast"

            if vim.fn.has("mac") == 1 and get_macos_theme() == "light" then
                vim.cmd("colorscheme github_light_high_contrast")
                -- vim.cmd("colorscheme github_light")
            else
                vim.cmd("colorscheme github_dark_dimmed")
            end
            -- vim.cmd("colorscheme github_dark_dimmed")
            -- vim.cmd("colorscheme github_light")
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        config = function()
            require("vscode").setup({})
        end,
    },
}
