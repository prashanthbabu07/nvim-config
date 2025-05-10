return {
	{
		"github/copilot.vim",
		lazy = false,

		config = function()
			-- Disable default <Tab> mapping
			vim.g.copilot_no_tab_map = true

			-- Custom key mapping for accepting suggestion
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

			-- OPTIONAL: Map for navigating suggestions
			vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { expr = true, silent = true })
			vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { expr = true, silent = true })

			-- OPTIONAL: Turn Copilot on/off
			vim.api.nvim_set_keymap("n", "<leader>cp", ":CopilotToggle<CR>", { silent = true })

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
	{
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				-- See Configuration section for options
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
				{ "<leader>zn", ":CopilotChat Rename<CR>", mode = "v", desc = "Rename the variable" },
				{ "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
				{ "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
				{ "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
				{ "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
				{ "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
				{ "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
				{ "<leader>zt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
				{ "<leader>zm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
				{ "<leader>zs", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
			},
			config = function()
				require("CopilotChat").setup({})
			end,
		},
	},
}
