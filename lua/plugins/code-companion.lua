return {
	"olimorris/codecompanion.nvim",
	-- commit = "7cc35b7f7f08d093469fa9ae67d3af716bd729c3",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ravitemer/codecompanion-history.nvim",
		"franco-ruggeri/codecompanion-spinner.nvim",
	},
	event = "VeryLazy",
	config = function()
		-- Normal Mode Keymaps
		vim.keymap.set("n", "<leader>ccc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Chat Panel" })
		vim.keymap.set("n", "<leader>cca", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions Menu" })

		-- Visual Selection Mode Keymaps (Evaluates highlights directly)
		vim.keymap.set("v", "<leader>cca", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions Menu" })
		vim.keymap.set("v", "<leader>cce", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add Selection to Chat Panel" })

		require("codecompanion").setup({
			log_level = "DEBUG", -- or "TRACE",
			completion = {
				provider = "copilot",
			},

			extensions = {
				spinner = {},
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "<leader>cch",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "<leader>ccs",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 0,
						-- Picker interface (auto resolved to a valid picker)
						picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
						---Optional filter function to control which chats are shown when browsing
						chat_filter = nil, -- function(chat_data) return boolean end
						-- Customize picker keymaps (optional)
						picker_keymaps = {
							rename = { n = "r", i = "<M-r>" },
							delete = { n = "d", i = "<M-d>" },
							duplicate = { n = "<C-y>", i = "<C-y>" },
						},
						---Automatically generate titles for new chats
						auto_generate_title = true,
						title_generation_opts = {
							---Adapter for generating titles (defaults to current chat adapter)
							adapter = nil, -- "copilot"
							---Model for generating titles (defaults to current chat model)
							model = nil, -- "gpt-4o"
							---Number of user prompts after which to refresh the title (0 to disable)
							refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
							---Maximum number of times to refresh the title (default: 3)
							max_refreshes = 3,
							format_title = function(original_title)
								-- this can be a custom function that applies some custom
								-- formatting to the title.
								return original_title
							end,
						},
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = false,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,

						-- Summary system
						summary = {
							-- Keymap to generate summary for current chat (default: "gcs")
							create_summary_keymap = "gcs",
							-- Keymap to browse summaries (default: "gbs")
							browse_summaries_keymap = "gbs",

							generation_opts = {
								adapter = nil, -- defaults to current chat adapter
								model = nil, -- defaults to current chat model
								context_size = 90000, -- max tokens that the model supports
								include_references = true, -- include slash command content
								include_tool_outputs = true, -- include tool execution results
								system_prompt = nil, -- custom system prompt (string or function)
								format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
							},
						},

						-- Memory system (requires VectorCode CLI)
						memory = {
							-- Automatically index summaries when they are generated
							auto_create_memories_on_summary_generation = true,
							-- Path to the VectorCode executable
							vectorcode_exe = "vectorcode",
							-- Tool configuration
							tool_opts = {
								-- Default number of memories to retrieve
								default_num = 10,
							},
							-- Enable notifications for indexing progress
							notify = true,
							-- Index all existing memories on startup
							-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
							index_on_startup = false,
						},
					},
				},
			},

			adapters = {
				-- Cloud Adapter: Explicitly configured for GPT-5.3-Codex
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-5.3-codex",
							},
						},
					})
				end,

				http = {
					ollama = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								-- Directs all traffic straight to your Arch machine
								url = "http://192.168.29.219:11435",
							},
							schema = {
								model = {
									-- default = "qwen3.5:4b",
									default = "gemma4:e4b",
								},
							},
						})
					end,
				},
			},

			-- Local Adapter: Quick, snappy 3B model for offline fallback or private files
			--     qwen_local = function()
			--         return require("codecompanion.adapters").extend("ollama", {
			--             schema = {
			--                 model = {
			--                     default = "qwen2.5-coder:3b",
			--                 },
			--             },
			--         })
			--     end,
			-- },

			interactions = {
				chat = { adapter = { name = "copilot", model = "gpt-5.3-codex" } },
				-- inline = { adapter = "copilot" },
				inline = { adapter = { name = "copilot", model = "gpt-5.3-codex" } },
				cmd = { adapter = "copilot" },
				-- chat = { adapter = "ollama" },
				-- chat = {
				--     adapter = "ollama",
				--     opts = {
				--         num_ctx = 1024, -- Clamp this down to 1024 tokens to force instant prompt parsing
				--         temperature = 0.0,
				--     },
				--     -- model = "qwen3:8b",
				--     -- opts = {
				--     -- 	num_ctx = 8192,
				--     -- },
				-- },
			},

			-- Custom Prompt Library integrating all of your custom actions safely
			prompt_library = require("config.codecompanion.prompt-library"),
			mcp = {
				servers = {
					filesystem = {
						cmd = { "npx", "-y", "@modelcontextprotocol/server-filesystem" },
						roots = function()
							-- Return a list of names and directories as per:
							-- https://modelcontextprotocol.io/specification/2025-11-25/client/roots#listing-roots
						end,
					},
				},
			},
		})
	end,
}
