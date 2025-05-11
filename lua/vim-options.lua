vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4 -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4 -- A tab is 4 spaces
vim.opt.softtabstop = 4 -- <Tab> inserts 4 spaces

-- Set indentation for specific file types
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "javascript", "lua", "html", "css" }, -- add others as needed
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
	end,
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.statuscolumn = " %s%1l   "

vim.g.mapleader = " "

vim.opt.cursorline = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.opt.splitright = true
-- vim.o.winborder = "rounded"  -- Options: "single", "double", "rounded", "shadow", etc.
--
--
--
vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#D0D0D0" })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#FAFAFA" })

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
	vim.api.nvim_set_hl(0, hl, { bg = bg_color })
end

vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = bg_color, bg = bg_color })
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = bg_color, bg = bg_color })

vim.api.nvim_set_hl(0, "LineNr", { fg = "#6a93b9", bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#6a93b9", bold = true, bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#6a93b9" })
vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#6a93b9" })

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#E0E0E0", bg = "#FAFAFA" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#FAFAFA" })
