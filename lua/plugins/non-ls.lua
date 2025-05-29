return {
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
                }),
                null_ls.builtins.formatting.csharpier, -- requires csharpier installed
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
            },
            filetypes = { "lua", "javascript", "typescript", "html", "css", "csharp", "rust", "python" },
        })

        vim.keymap.set("n", "<leader>lsf", vim.lsp.buf.format, {
            desc = "Format curent buffer",
        })
    end,
}
