vim.api.nvim_create_user_command("TypoScan", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local dir = args[1] or "src"
    local ext = args[2] or "cs"

    print("Scanning " .. dir .. " for ." .. ext .. " typos...")

    -- Run cspell
    local cmd = string.format('cspell "%s/**/*.%s" --exclude "**/*.Sdk/**" --no-progress --no-summary', dir, ext)
    local output = vim.fn.system(cmd)

    if output == "" or output == nil then
        print("No typos found!")
    else
        -- 1. Load the results into the quickfix list (background)
        vim.fn.setqflist({}, "r", { title = "CSpell", lines = vim.split(output, "\n") })

        -- 2. Open those results in Telescope
        local ok, telescope = pcall(require, "telescope.builtin")
        if ok then
            telescope.quickfix()
        else
            -- Fallback to standard quickfix if Telescope isn't installed
            vim.cmd("copen")
        end
    end
end, {
    nargs = "*",
    complete = "dir",
    desc = "Scan for typos and open in Telescope",
})
