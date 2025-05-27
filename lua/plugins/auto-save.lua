return {
    -- "prashanthbabu07/auto-save.nvim",
    dir = "/Volumes/Sandisk/Projects/neovim-projects/auto-save.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("auto-save").setup({
            delay_events = { "InsertLeave" },
            -- instant_events = { "FocusLost", "BufLeave" },
        })
    end,
}
