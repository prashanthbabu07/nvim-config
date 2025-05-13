return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
            vim.keymap.set("n", "<leader>gP", ":Git push<CR>", { desc = "Git push" })
            vim.keymap.set("n", "<leader>gp", ":Git pull<CR>", { desc = "Git pull" })
            vim.keymap.set("n", "<leader>gL", ":Git pull --rebase<CR>", { desc = "Git pull rebase" })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()

            vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
            vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Preview hunk" })
        end,
    },
}
