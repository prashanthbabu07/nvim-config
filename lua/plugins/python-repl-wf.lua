return -- lazy.nvim
{
    "jpalardy/vim-slime",
    config = function()
        vim.g.slime_target = "tmux"
        vim.g.slime_python_ipython = 1
        vim.g.slime_dont_ask_default = 0
        vim.g.slime_default_config = {
            socket_name = "default",
            target_pane = "0.1", -- Change to your tmux target pane
        }
    end,
}
