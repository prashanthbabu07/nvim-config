-- https://github.com/catppuccin/nvim

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.g.catppuccin_flavour = "latte"
		vim.cmd.colorscheme = "catppuccin"
	end,
}
