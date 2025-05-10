
vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4 -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4 -- A tab is 4 spaces
vim.opt.softtabstop = 4 -- <Tab> inserts 4 spaces

-- vim.cmd("set expandtab")
-- vim.cmd("set tabstop=4")
-- vim.cmd("set softtabstop=4")
-- vim.cmd("set shiftwidth=4")

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
vim.opt.numberwidth = 1
vim.opt.statuscolumn = "%s%1l   "
-- vim.opt.relativenumber = true
vim.g.mapleader = " "
vim.g.background = "light"
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- vim.o.background = "light"
-- vim.cmd("colorscheme PaperColor")

vim.opt.cursorline = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.opt.splitright = true
-- vim.o.winborder = "bold"  -- Options: "single", "double", "rounded", "shadow", etc.

