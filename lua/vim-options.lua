vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
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

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')


