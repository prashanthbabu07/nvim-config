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
                        prefix = " // ",      -- Subtle separator
                    },
                    providers = {
                        {
                            name = "references",
                            enabled = true,
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
