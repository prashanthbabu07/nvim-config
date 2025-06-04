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
            local start_line = vim.fn.search("^# %%", "bnW") -- Search backward for # %% at line start
            if start_line == 0 then
                start_line = 1
            end

            local end_line = vim.fn.search("^# %%", "nW") -- Search forward for next # %%
            if end_line == 0 then
                end_line = vim.fn.line("$") + 1
            end

            local lines = vim.fn.getline(start_line, end_line - 1)
            vim.fn["slime#send"](table.concat(lines, "\n"))
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
