-- This script automatically saves the current buffer when leaving insert mode or when text changes.

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified then
            vim.cmd("silent! write")
            vim.notify("Auto-saved!", vim.log.levels.INFO, { title = "Neovim" })
        end
    end,
})

