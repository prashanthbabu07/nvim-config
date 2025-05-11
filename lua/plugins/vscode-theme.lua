return {
	"Mofiqul/vscode.nvim",
	config = function()
		-- Lua:
		-- For dark theme (neovim's default)
		-- vim.o.background = "dark"
		--
		-- For light theme
		-- vim.o.background = "light"

		-- load the theme module
		local vscode = require("vscode")

		-- setup (optional: tweak to your liking)
		vscode.setup({
			transparent = false,
			italic_comments = true,
			disable_nvimtree_bg = false,
			bold_keywords = true,
			-- Enable the following theme style, options are:
			-- dark (default) | light | storm | dawn | tokyonight
			style = "light",
		})

		-- apply the light theme
		vscode.load("light")
		vim.cmd.colorscheme("vscode")
	end,
}
