return {
    "prashanthbabu07/auto-save.nvim",
    priority = 1000,
    config = function()
        require("auto-save").setup({
            delay_events = { "InsertLeave", "TextChanged" },
            -- instant_events = { "FocusLost", "BufLeave" },
        })
    end,
}
