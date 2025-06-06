return -- lazy.nvim
{
    "jpalardy/vim-slime",
    config = function()
        vim.g.slime_target = "tmux"
        vim.g.slime_python_ipython = 1
        vim.g.slime_dont_ask_default = 1
        vim.g.slime_default_config = {
            socket_name = "default",
            target_pane = "0.1", -- Change to your tmux target pane
        }
        vim.g.slime_bracketed_paste = 1

        -- Function to send current # %% cell
        function SendCurrentCell()
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

            for _, line_content in ipairs(lines_to_send) do
                if line_content:match("^s*$") then
                else
                    vim.fn["slime#send"](line_content .. "\n")
                end
            end

            -- goto next cell
            local target_cursor_line = end_line
            if target_cursor_line > vim.fn.line("$") then
                target_cursor_line = vim.fn.line("$")
            end
            vim.api.nvim_win_set_cursor(0, { target_cursor_line, 0 }) -- 0 for current window, 0 for column 0 (beginning of line)
            -- Alternatively, using vim.fn.cursor:
            -- vim.fn.cursor(target_cursor_line, 1) -- 1-indexed column

            -- local lines = vim.fn.getline(start_line, end_line - 1)
            -- vim.fn["slime#send"](table.concat(lines, "\n"))
        end

        -- Map <leader>r to send the current cell
        vim.keymap.set("n", "<leader>pr", SendCurrentCell, {
            noremap = true,
            silent = true,
            desc = "Send current Python cell to IPython",
        })

        -- In your Lazy.nvim plugin config or a keymap file
        -- vim.keymap.set("n", "<leader>pr", "<Plug>SlimeParagraphSend", { silent = true })

        -- Optional: Map <leader>sc to quickly run :SlimeConfig
        -- vim.keymap.set("n", "<leader>sc", ":SlimeConfig<CR>", {
        --     noremap = true,
        --     silent = true,
        --     desc = "Set Slime target pane",
        -- })
    end,
}
