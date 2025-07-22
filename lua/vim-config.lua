vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4   -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4      -- A tab is 4 spaces
vim.opt.softtabstop = 4  -- <Tab> inserts 4 spaces

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
vim.o.signcolumn = "yes:2"
vim.opt.statuscolumn = "%s%1l   "

-- typewriter like scrolling
vim.opt.scrolloff = 999


vim.opt.fillchars:append({ eob = " " })

vim.g.mapleader = " "

vim.opt.cursorline = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "K", "<Nop>")

vim.opt.splitright = true

-- Show menu for command line
vim.cmd("set wildmenu")
-- vim.cmd("set wildoptions=pum")
vim.cmd("set wildmode=list:longest")

-- vim.filetype.add({
--     extension = {
--         cshtml = "cshtml",
--     },
-- })

-- map tabnext to cycle through tabs
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { silent = true, desc = "Next tab" })

-- create a new tab
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { silent = true, desc = "New tab" })

-- map goto tab number to open tab 1-9
for i = 1, 9 do
    vim.keymap.set("n", "<leader>t" .. i, ":tabnext " .. i .. "<CR>", { silent = true, desc = "Tab " .. i })
end

-- map close tab 
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close tab" })


