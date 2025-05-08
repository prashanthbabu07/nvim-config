return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.prettier,
				-- null_ls.builtins.diagnostics.eslint,
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
				null_ls.builtins.formatting.csharpier, -- requires csharpier installed
                -- null_ls.builtins.diagnostics.csharp_ls,
				-- null_ls.builtins.diagnostics.omnisharp, -- for linting if available
			},
		})

		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
	end,
}
