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
			-- lspconfig.rust_analyzer.setup({
			--     -- capabilities = capabilities,
			-- })

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

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.declaration, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set({ "n", "v" }, "<leader>E", vim.diagnostic.open_float, {})
            vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, {})


            vim.keymap.set("n", "<leader>ref", require('telescope.builtin').lsp_references, { desc = "Find references (Telescope)" })
		end,
	},
}
