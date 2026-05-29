-- return {
--     "VidocqH/lsp-lens.nvim",
--     event = "LspAttach",
--     config = function()
--         require("lsp-lens").setup()
--     end,
-- }
return {
    "oribarilan/lensline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LspAttach",
    config = function()
        require("lensline").setup({
            profiles = {
                {
                    name = "default",
                    style = {
                        placement = "inline", -- This keeps it on the same line!
                        prefix = "", -- Subtle separator
                    },
                    -- providers = {
                    --     {
                    --         name = "usages",
                    --         enabled = true,
                    --         include = { "refs", "defs", "impls" },
                    --         breakdown = true,
                    --     },
                    --     { name = "diagnostics", enabled = true, min_level = "HINT" },
                    --     { name = "complexity", enabled = true },
                    -- },
                    providers = {
                        {
                            name = "references",
                            -- name = "usages",
                            enabled = true,
                            -- include = { "refs", "defs", "impls" },
                            include = { "refs" },
                            -- Optional: only show if there are more than 0 references
                            filter = function(count)
                                return count > 0
                            end,
                        },
                    },
                },
            },
        })
    end,
}
