return {
    "shoebox/speckit.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        -- Terminal backend: "native" (default), "floaterm", or "agentic"
        terminal = {
            backend = "native",
            -- Agent CLI command template. Use %s for speckit command.
            -- Use two %s for (cwd, command). Default: "claude -p %s"
            -- agent_cmd = "claude -p %s",
            -- we use copilot 
            agent_cmd = "copilot speckit %s",
        },
        -- Optional: customize icons
        icons = {
            passed = "",
            skipped = "",
        },
    },
    keys = {
        { "<leader>sk", "<cmd>SpeckitPick<cr>", desc = "Spec Kit - Pick a spec" },
        { "<leader>sc", "<cmd>SpeckitConstitution<cr>", desc = "Spec Kit - Run constitution" },
        { "<leader>ss", "<cmd>SpeckitSpecify<cr>", desc = "Spec Kit - Run specify" },
        { "<leader>sP", "<cmd>SpeckitPlan<cr>", desc = "Spec Kit - Run plan" },
        { "<leader>st", "<cmd>SpeckitTasks<cr>", desc = "Spec Kit - Run tasks" },
        { "<leader>si", "<cmd>SpeckitImplement<cr>", desc = "Spec Kit - Pick task to implement" },
        { "<leader>so", "<cmd>SpeckitOverview<cr>", desc = "Spec Kit - Overview" },
        { "<leader>sn", "<cmd>SpeckitSuggest<cr>", desc = "Spec Kit - Suggest next phase" },
    },
}
