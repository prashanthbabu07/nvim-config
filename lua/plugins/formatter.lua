return {
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua.with({
                        extra_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                    }),
                    null_ls.builtins.completion.spell,
                    null_ls.builtins.formatting.prettier.with({
                        extra_args = { "--use-tabs=false", "--tab-width=4" },
                        -- filetypes = { "json", "jsonc", "markdown", "markdown.mdx", "css",  },
                    }),
                    null_ls.builtins.formatting.csharpier, -- requires csharpier installed
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.clang_format.with({
                        filetypes = { "c", "cpp", "objc", "objcpp" }, -- Ensure these filetypes are included
                        extra_args = {
                            "--style={BasedOnStyle: Google, IndentWidth: 4, UseTab: Never, TabWidth: 4}",
                        },
                    }),
                },
                filetypes = {
                    "lua",
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "csharp",
                    "rust",
                    "python",
                    "c",
                    "cpp",
                    "objc",
                    "objcpp",
                    "json",
                    "jsonc",
                    "markdown",
                    "markdown.mdx",
                    "yaml",
                },
            })

            vim.keymap.set("n", "<leader>lsf", vim.lsp.buf.format, {
                desc = "LSP format",
            })
        end,
    },
    {
        "junegunn/vim-easy-align",
        lazy = false,
        -- keys = {
        --     { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
        -- },
        config = function()
            vim.keymap.set("v", "<leader>fae", "<Plug>(EasyAlign)=", { desc = "Align on '='" })
            vim.keymap.set("v", "<leader>fac", "<Plug>(EasyAlign),", { desc = "Align on ','" })
        end,
    },
}
