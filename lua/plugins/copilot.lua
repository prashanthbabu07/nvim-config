return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
        lazy  = false,
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			options = {
				prompts = {
					Rename = {
						prompt = "Please rename the variable correctly in given selection based on context",
						selection = function(source)
							local copilot_select = require("CopilotChat.select")
							return copilot_select.visual(source)
						end,
					},
				},
			},
		},
		keys = {
			{ "<leader>ccn", ":CopilotChat Rename<CR>", mode = "v", desc = "Rename the variable" },
			{ "<leader>ccc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
			{ "<leader>cce", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
			{ "<leader>ccr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
			{ "<leader>ccf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
			{ "<leader>cco", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
			{ "<leader>cpd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
			{ "<leader>cpt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
			{ "<leader>cpm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
			{ "<leader>cps", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
		},
		config = function()
			require("CopilotChat").setup({})

			-- Disable default <Tab> mapping
			vim.g.copilot_no_tab_map = true

			-- Custom key mapping for accepting suggestion
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

			-- OPTIONAL: Map for navigating suggestions
			vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { expr = true, silent = true })
			vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { expr = true, silent = true })

			-- OPTIONAL: Turn Copilot on/off
			vim.api.nvim_set_keymap("n", "<leader>cpt", ":CopilotToggle<CR>", { silent = true })

			-- OPTIONAL: Set up a custom command to toggle Copilot
			vim.api.nvim_create_user_command("CopilotToggle", function()
				if vim.g.copilot_enabled then
					vim.g.copilot_enabled = false
					print("Copilot disabled")
				else
					vim.g.copilot_enabled = true
					print("Copilot enabled")
				end
			end, { desc = "Toggle GitHub Copilot" })

			-- You can also set global settings if needed
			vim.g.copilot_filetypes = {
				["*"] = true, -- Enable for all filetypes
				markdown = true, -- Disable for markdown
				yaml = true, -- Disable for yaml
			}
		end,
	},
}
