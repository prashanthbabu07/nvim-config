-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = { import = "plugins" },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    --	install = { colorscheme = { "PaperColor" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
    change_detection = {
        notify = false, -- disables the "# Config Change Detected" message
    },
    -- ui = {
    -- 	border = "rounded", -- Or "single", "shadow", or a custom border
    -- },
})

--[[ vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end, { desc = "Format current buffer" })
]]

require("vim-config")
require("custom-colors")
require("utils.editor")
local stickynotes = require("utils.sticky-notes")
vim.keymap.set("n", "<leader>sna", stickynotes.add_note, { desc = "Add sticky note" })
vim.keymap.set("n", "<leader>sns", stickynotes.show_current_note, { desc = "Show sticky note" })
