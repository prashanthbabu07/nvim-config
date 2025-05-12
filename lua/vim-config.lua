vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4 -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4 -- A tab is 4 spaces
vim.opt.softtabstop = 4 -- <Tab> inserts 4 spaces

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.statuscolumn = " %s%1l   "

vim.g.mapleader = " "

vim.opt.cursorline = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
-- vim.keymap.set("n", "K", "<Nop>")


vim.opt.splitright = true
