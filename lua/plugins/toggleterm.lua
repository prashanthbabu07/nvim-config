return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local tt = require("toggleterm")
        tt.setup({
            size = 20,
            open_mapping = [[<C-\>]],
            direction = "float", -- Can be 'vertical' | 'tab' | 'float'
            close_on_exit = true,
            shade_terminals = false,
            -- shade_factor = 0.1,
        })
    end,
}
