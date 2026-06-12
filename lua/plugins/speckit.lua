return {
	"shoebox/spec-kit.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		terminal = {
			backend = "native",
			-- Fix: Added the interactive flag (-i) or prompt flag (-p)
			-- so Copilot knows how to parse the incoming command string.
			-- agent_cmd = "copilot -i 'speckit %s'",
            agent_cmd = "copilot -p \"speckit %s\"",
		},
		icons = {
			passed = "✅",
			skipped = "⏭️",
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
