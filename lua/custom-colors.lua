local colors = {
    yellow = "#fae2af",
    red = "#ff0000",
}

vim.api.nvim_set_hl(0, "DapStoppedLine", {
    bg = colors.yellow,
    underline = false,
})

vim.api.nvim_set_hl(0, "DapStopped", {
    fg = colors.red,
    bg = colors.yellow,
})

vim.fn.sign_define("DapStopped", {
    text = "→",
    texthl = "DapStopped",
    linehl = "DapStoppedLine",
    numhl = "DapStoppedLine",
})

vim.api.nvim_set_hl(0, "DapBreakpoint", {
    fg = colors.red, -- symbol color
    -- bg = cp.base, -- optional background
})

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "x", texthl = "DapBreakpoint", linehl = "", numhl = "" })

-- matching paris
-- vim.cmd("highlight MatchParen cterm=bold ctermbg=lightgrey ctermfg=NONE gui=bold guibg=lightgrey guifg=NONE")
