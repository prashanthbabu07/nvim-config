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
				-- null_ls.builtins.diagnostics.eslint,
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
				null_ls.builtins.formatting.csharpier, -- requires csharpier installed
				-- null_ls.builtins.diagnostics.csharp_ls,
				-- null_ls.builtins.diagnostics.omnisharp, -- for linting if available
			},
			filetypes = { "lua", "javascript", "typescript", "html", "css", "csharp", "rust" },
		})

		vim.keymap.set("n", "<leader>lsf", vim.lsp.buf.format, {
			desc = "Format curent buffer",
		})
	end,
}
