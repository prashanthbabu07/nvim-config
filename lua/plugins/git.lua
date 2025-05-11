return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },              -- Loads only when you call :Git or :G
    config = function()
        -- vim.api.nvim_del_user_command("Git") -- Remove existing if any
        vim.api.nvim_create_user_command("VGit", function(opts)
            local args = table.concat(opts.fargs, " ")
            vim.cmd("vert Git " .. args)
        end, {
            nargs = "*",
            complete = "customlist,fugitive#Complete", -- Tab completion from fugitive
        })
    end,
}
