-- This script automatically saves the current buffer when leaving insert mode or when text changes.

local autosave_timer = nil

local save_with_delay = function()
    if vim.bo.modified then
        -- Cancel the previous timer if still running
        if autosave_timer then
            autosave_timer:stop()
        end
        -- Set a short delay (e.g., 500ms) before saving test
        autosave_timer = vim.defer_fn(function()
            vim.cmd("silent! write")
            vim.api.nvim_echo({ { "Auto-saved!", "None" } }, false, {})
            -- vim.notify("Auto-saved!", vim.log.levels.INFO, { title = "Neovim" })
        end, 2000)
    end
end

local auto_save = function()
    if vim.bo.modifiable and vim.bo.modified then
        vim.cmd("silent! write")
        vim.api.nvim_echo({ { "Auto-saved!", "None" } }, false, {})
    end
end

-- vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend", "BufLeave" }, {
--     callback = auto_save,
-- })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = save_with_delay,
})

-- Optional: Clear the timer on BufWritePre to avoid saving twice
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        if autosave_timer then
            vim.timer.stop(autosave_timer)
            autosave_timer = nil
        end
    end,
})

-- vim.api.nvim_create_autocmd({ "VimSuspend", "FocusLost" }, { command = "w" })
