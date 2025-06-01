-- stickynotes.lua
local M = {}

-- Store notes in memory
M.notes = {}

-- Show the note in a floating window
function M.show_note(bufnr, line)
    local note = M.notes[bufnr] and M.notes[bufnr][line]
    if not note then
        print("No note for this line.")
        return
    end

    -- Create a new buffer
    local float_buf = vim.api.nvim_create_buf(false, true)

    -- Set buffer content
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, vim.split(note, "\n"))

    -- Open floating window
    vim.api.nvim_open_win(float_buf, true, {
        relative = "cursor",
        width = 40,
        height = 5,
        col = 1,
        row = 1,
        style = "minimal",
        border = "single",
    })
end

function M.custom_input(prompt, callback)
    local buf = vim.api.nvim_create_buf(false, true)
    local width = 50
    local height = 3

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
        style = "minimal",
        border = "single",
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt or "Enter your note..." })
    vim.api.nvim_buf_add_highlight(buf, -1, "Question", 0, 0, -1)

    -- Move to input line
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, { "" })
    vim.api.nvim_win_set_cursor(win, { 2, 0 })

    -- Handle <CR> key
    vim.keymap.set("n", "<CR>", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 1, 2, false)
        local input = lines[1]
        vim.api.nvim_win_close(win, true)
        callback(input)
    end, { buffer = buf, nowait = true })
end

-- Attach to buffer changes
function M.attach_buffer(bufnr)
    if M.attached_buffers and M.attached_buffers[bufnr] then
        return
    end
    M.attached_buffers = M.attached_buffers or {}
    M.attached_buffers[bufnr] = true

    vim.api.nvim_buf_attach(bufnr, false, {
        on_lines = function(_, buf, _, first_line, last_line, new_last_line, _)
            if not M.notes[buf] then
                return
            end

            local new_notes = {}
            for line, note in pairs(M.notes[buf]) do
                -- If line is before the deleted range, keep it
                if line < first_line + 1 then
                    new_notes[line] = note
                    -- If line is after the changed range, shift accordingly
                elseif line >= last_line + 1 then
                    local delta = new_last_line - last_line
                    new_notes[line + delta] = note
                end
                -- else: line is deleted, so we drop it
            end

            M.notes[buf] = new_notes
        end,
    })
end

-- Add/edit a note for the current line
function M.add_note()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1]

    M.attach_buffer(bufnr) -- Ensure buffer is tracked

    local input_buf = vim.api.nvim_create_buf(false, true)
    local width, height = 60, 10

    local win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, { "-- Write your note below. Press <leader>sns to save it." })
    -- set cursor to 2nd line
    -- vim.api.nvim_buf_add_highlight(input_buf, -1, "Comment", 0, 0, -1) this is deprecated. Need to use a different method 
    -- highlight the first line
    vim.api.hl.range(input_buf, 0, 0, -1, { bg = "#3c3836", fg = "#fabd2f" }) -- Highlight first line with a custom color
    vim.api.nvim_buf_set_lines(input_buf, 1, -1, false, { "" })
    vim.api.nvim_win_set_cursor(win, { 2, 0 })

    
    -- vim.api.nvim_buf_add_highlight(input_buf, -1, "Comment", 0, 0, -1)

    -- Mapping: save with <leader>sns inside the floating window
    vim.keymap.set("n", "<leader>sns", function()
        local lines = vim.api.nvim_buf_get_lines(input_buf, 1, -1, false)
        local note = table.concat(lines, "\n")
        vim.api.nvim_win_close(win, true)

        M.notes[bufnr] = M.notes[bufnr] or {}
        M.notes[bufnr][line] = note
        print("Note saved for line " .. line)
    end, { buffer = input_buf, desc = "Save sticky note" })
end

-- Show note for current line
function M.show_current_note()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    M.show_note(bufnr, line)
end

return M
