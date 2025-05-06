return {
	"Mofiqul/vscode.nvim",
	config = function()
		-- Lua:
		-- For dark theme (neovim's default)
		-- vim.o.background = "dark"
		-- For light theme
		vim.o.background = "light"

		-- load the theme module
		local vscode = require("vscode")

		-- setup (optional: tweak to your liking)
		vscode.setup({
			-- possible options:
			-- transparent = false,
			-- italic_comments = true,
			-- disable_nvimtree_bg = true,
		})

		-- apply the light theme
		vscode.load("light")
		-- vim.cmd.colorscheme("vscode")

		-- Fix neo-tree background issue
		-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
		-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
		-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
	end,
}
