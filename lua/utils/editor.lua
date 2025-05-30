local M = {}

function M.extract_lines_to_file()
    -- Get visual selection range
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local end_line = end_pos[2]

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

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

    -- Extract selected lines
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    print(start_line, end_line, lines)

    -- Write to file
    local file, err = io.open(filename, "w")
    if not file then
        print("Error opening file: " .. err)
        return
    end
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()

    -- Delete lines from buffer
    if start_line <= end_line then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
    end

    print("Saved selection to " .. filename .. " and deleted from buffer.")

    -- Write selected lines to file and delete them from buffer
    -- local save_cmd = string.format(":'<,'>w %s | '<,'>d", filename)
    -- vim.cmd(save_cmd)
    -- print("Saved selection to " .. filename .. " and deleted from buffer.")
end

-- Keymap: visual mode only
vim.keymap.set("v", "<leader>xf", function()
    M.extract_lines_to_file()
end, { desc = "Extract lines to file and delete", silent = true })

return M
