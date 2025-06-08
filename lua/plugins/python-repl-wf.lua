return -- lazy.nvim
{
    {
        "Vigemus/iron.nvim",
        config = function()
            local iron = require("iron.core")

            local function send_current_cell()
                -- search line starting with # %% including the current line
                local start_line = vim.fn.search("^# %%", "bnW") -- Search backward for # %% at line start
                if start_line == 0 then
                    start_line = 1
                end

                local end_line = vim.fn.search("^# %%", "nW") -- Search forward for next # %%
                if end_line == 0 then
                    end_line = vim.fn.line("$") + 1
                end

                if vim.fn.getline(start_line):match("^# %%") then
                    start_line = start_line + 1
                end
                if vim.fn.getline(end_line - 1):match("^# %%") then
                    end_line = end_line - 1
                end

                local lines_to_send = vim.fn.getline(start_line, end_line - 1)
                if type(lines_to_send) ~= "table" then
                    lines_to_send = { lines_to_send }
                end

                for _, line in ipairs(lines_to_send) do
                    if not line:match("^s*$") and not line:match("^%s*#") then
                        require("iron.core").send(nil, { line })
                    end
                end

                -- goto next cell
                local target_cursor_line = end_line
                if target_cursor_line > vim.fn.line("$") then
                    target_cursor_line = vim.fn.line("$")
                end
                vim.api.nvim_win_set_cursor(0, { target_cursor_line, 0 }) -- 0 for current window, 0 for column 0 (beginning of line)
            end

            iron.setup({
                config = {
                    repl_definition = {
                        python = {
                            command = { "ipython", "--no-autoindent" },
                        },
                    },
                    repl_open_cmd = "vsplit",
                },
                keymaps = {
                    -- send_motion = "<leader>psc",
                    visual_send = "<leader>psc",
                    send_line = "<leader>psl",
                    send_file = "<leader>psf",
                    send_mark = "<leader>psm",
                    mark_motion = "<leader>psm",
                    mark_visual = "<leader>psm",
                    remove_mark = "<leader>psx",
                    cr = "<leader>ps<CR>",
                },
                highlight = {
                    italic = false,
                },
                ignore_blank_lines = true,
            })

            vim.keymap.set("n", "<leader>psc", send_current_cell, { desc = "Iron: Send current cell" })
        end,
    },
}
