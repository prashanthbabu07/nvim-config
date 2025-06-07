return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "isak102/telescope-git-file-history.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("git_file_history")
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
            vim.keymap.set("n", "<leader>gbt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
        end,
    },
}
