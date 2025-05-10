-- https://github.com/neovim/nvim-lspconfig

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"rust_analyzer",
					"csharp_ls",
					"pyright",
					"ruff",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		-- "Hoffs/omnisharp-extended-lsp.nvim",

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			-- local telescope = require("telescopes.builtin")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})

			-- PYRIGHT: type-check, code nav
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- disable pyright formatting
					client.server_capabilities.documentFormattingProvider = false
				end,
			})

			-- RUFF (the new LSP)
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- optional: disable hover to let pyright handle it
					client.server_capabilities.hoverProvider = false
				end,
				init_options = {
					settings = {
						args = {}, -- you can pass custom ruff args here if needed
					},
				},
			})

			lspconfig.csharp_ls.setup({
				cmd = { "csharp-ls" }, -- Ensure csharp-ls is in your PATH
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr }
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
				end,
				root_dir = lspconfig.util.root_pattern("*.sln", ".git", "*.csproj"),
			})

			-- lspconfig.omnisharp.setup({
			-- 	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			-- 	enable_editorconfig_support = true,
			-- 	enable_roslyn_analyzers = true,
			-- 	organize_imports_on_format = true,
			-- 	--[[enable_import_completion = true,
			-- 	handlers = {
			-- 		["textDocument/definition"] = require("omnisharp_extended").handler,
			-- 	},]]
			-- })

			vim.diagnostic.config({
				virtual_text = {
					severity = { min = vim.diagnostic.severity.HINT },
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			vim.keymap.set("n", "<leader>lsH", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "<leader>lsd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>lsD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			vim.keymap.set({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, { desc = "Code action" })
			-- vim.keymap.set({ "n", "v" }, "<leader>E", vim.diagnostic.open_float, {}, { desc = "Show diagnostics" })
			vim.keymap.set("n", "<leader>lsh", vim.lsp.buf.signature_help, { desc = "Signature help" })

			vim.keymap.set(
				"n",
				"<leader>lsr",
				require("telescope.builtin").lsp_references,
				{ desc = "Find references (Telescope)" }
			)
		end,
	},
}
