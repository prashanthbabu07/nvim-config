return {
	"Mofiqul/vscode.nvim",
	config = function()
		-- Lua:
		-- For dark theme (neovim's default)
		-- vim.o.background = "dark"
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
		-- vscode.load("light")
		vim.cmd.colorscheme("vscode")
		--
		vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#D0D0D0" })
		vim.api.nvim_set_hl(0, "Normal", { bg = "#FAFAFA" })

		local bg_color = "#FAFAFA"
		local hl_groups = {
			"Normal",
			"NormalNC",
			"SignColumn",
			"StatusLine",
			"StatusLineNC",
			"VertSplit",
			"EndOfBuffer",
			"LineNr",
			"CursorLineNr",
			"WinSeparator",
			"FoldColumn",
			"NeoTreeNormal",
			"NeoTreeNormalNC",
			"NeoTreeEndOfBuffer",
			"NeoTreeStatusLine",
			"NeoTreeVertSplit",
		}
		for _, hl in ipairs(hl_groups) do
			vim.api.nvim_set_hl(0, hl, { bg = bg_color  })
		end

		-- vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = bg_color, bg = bg_color })
		-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = bg_color, bg = bg_color })

		--
		-- Light grey background fix for neo-tree
		-- local light_grey = "#E5E5E5"
		--       local cursor_line = "#D0D0D0"
		--
		--
		-- local groups = {
		-- 	"NeoTreeNormal",
		-- 	"NeoTreeNormalNC",
		-- 	"NeoTreeEndOfBuffer",
		-- 	"NeoTreeWinSeparator",
		-- 	"NormalFloat",
		-- 	"NeoTreeFloatNormal",
		-- 	"NeoTreePopup",
		-- }
		--
		-- for _, group in ipairs(groups) do
		-- 	vim.api.nvim_set_hl(0, group, { bg = light_grey })
		-- end
		--
		--       -- vim.api.nvim_set_hl(0, "CursorLine", { bg = cursor_line })
		-- vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#D0D0D0" })

		-- Fix neo-tree background issue
		-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
		-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
		-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = "NONE", bg = light_grey })
		-- vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#E5E5E5", bg = "#E5E5E5" })
	end,
}
