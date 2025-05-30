local M = {}

function M.extract_lines_to_file()

    local filename = vim.fn.input("Save selection to file: ", "", "file")

    if filename == nil or filename == "" then
        print("No filename provided, aborting.")
        return
    end

    -- Check if the file already exists
    if vim.fn.filereadable(filename) == 1 then
        local confirm = vim.fn.input(filename .. " already exists. Overwrite? (y/n): ")
        if confirm:lower() ~= "y" then
            print("Aborted.")
            return
        end
    end

    -- Write selected lines to file and delete them from buffer
    local save_cmd = string.format(":'<,'>w %s | '<,'>d", filename)
    vim.cmd(save_cmd)
    print("Saved selection to " .. filename .. " and deleted from buffer.")
end

-- Keymap: visual mode only
vim.keymap.set("v", "<leader>xf", function()
    M.extract_lines_to_file()
end, { desc = "Extract lines to file and delete", silent = true })

return M
