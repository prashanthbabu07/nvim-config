vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4   -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4      -- A tab is 4 spaces
vim.opt.softtabstop = 4  -- <Tab> inserts 4 spaces

-- Set indentation for specific file types
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "javascript", "lua", "html", "css" }, -- add others as needed
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.o.signcolumn = "yes:2"
vim.opt.statuscolumn = "%s%1l   "

-- typewriter like scrolling
-- vim.opt.scrolloff = 999
-- vim.api.
-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--     callback = function()
--         vim.cmd("normal! zz")
--     end,
-- })

vim.opt.fillchars:append({ eob = " " })

vim.g.mapleader = " "

vim.opt.cursorline = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "K", "<Nop>")

vim.opt.splitright = true

-- Show menu for command line
vim.cmd("set wildmenu")
-- vim.cmd("set wildoptions=pum")
vim.cmd("set wildmode=list:longest")

-- vim.filetype.add({
--     extension = {
--         cshtml = "cshtml",
--     },
-- })

-- map tabnext to cycle through tabs
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { silent = true, desc = "Next tab" })

-- create a new tab
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { silent = true, desc = "New tab" })

-- map goto tab number to open tab 1-9
for i = 1, 9 do
    vim.keymap.set("n", "<leader>t" .. i, ":tabnext " .. i .. "<CR>", { silent = true, desc = "Tab " .. i })
end

-- map close tab
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close tab" })

-- disable lsp logging
-- vim.lsp.set_log_level("off")

-- Copy filename and line number to clipboard
local function copy_filename_line()
    local filename = vim.fn.expand("%:t")  -- Get the current file name
    local line = vim.fn.line(".")          -- Get the current line number
    local text = filename .. ":" .. line   -- Format as "filename:line"

    vim.fn.setreg("+", text)               -- Copy to system clipboard
    print("Copied to clipboard: " .. text) -- Optional: Notify the user
end

vim.keymap.set("n", "<leader>cf", copy_filename_line, { desc = "Copy filename and line number" })

-- For init.lua
-- vim.opt.background = "light"
-- vim.cmd("colorscheme default")
-- vim.cmd("hi Normal guibg=#FFFFFF ctermbg=White")
--

-- Disable folding by default
vim.opt.foldenable = false

-- vim.opt.foldmethod = 'marker'
-- vim.opt.foldmarker = '#region,#endregion'

-- vim.opt.fillchars:append({ fold = " " })
-- replace --- with a space in the fold text
-- vim.opt.foldtext = "%f %l %s"

_G.minimal_foldtext = function()
    local line_text = vim.fn.getline(vim.v.foldstart)
    local hidden_lines = vim.v.foldend - vim.v.foldstart + 1
    local count_text = string.format(" %d lines: ", hidden_lines)

    return count_text .. line_text
end

-- vim.opt.foldtext = "v:lua.minimal_foldtext()"
vim.opt.fillchars:append({ fold = " " })

local my_theme = require("theme.light")
my_theme.load()

local theme_manager = require("theme.theme")

-- Initialize on startup based on system theme
theme_manager.init_system_theme()

-- Map the toggle to <leader>th (or any key combination you prefer)
vim.keymap.set("n", "<leader>th", function()
    theme_manager.toggle()
end, { desc = "Toggle light/dark theme profiles" })

vim.o.laststatus = 3               -- Keep a single global statusline at the bottom
vim.o.statusline = " %f %m %= %y " -- Show only: [Relative Path] [Modified Flag] === [Filetype]

-- Force the native status line background to blend invisibly into your theme canvas
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#768390", bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#545d68", bg = "NONE", ctermbg = "NONE" })

-- Define the native format
-- %t = tail of file name (just the name, no paths)
-- %m = modified flag ([+])
-- %= = separation point (pushes everything after this to the right side)
-- 1. Core Native Statusline Structural Order
-- We call our global Lua helper function to process all structural metadata
vim.o.statusline = "%!v:lua.get_custom_statusline()"

-- 2. Master Formatter Function
function _G.get_custom_statusline()
    -- Map native modes to short, clean textual indicators
    local mode_map = {
        ["n"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["i"] = "INSERT",
        ["R"] = "REPLACE",
        ["c"] = "COMMAND",
        ["t"] = "TERMINAL",
    }

    local current_mode = vim.api.nvim_get_mode().mode
    local mode_str = mode_map[current_mode] or "NORMAL"

    -- Gather Git Branch Data
    local branch = ""
    if vim.g.loaded_fugitive == 1 then
        -- If using tpope/vim-fugitive
        branch = vim.fn.FugitiveHead()
    elseif pcall(require, "gitsigns") then
        -- If using gitsigns.nvim
        local gs_status = vim.b.gitsigns_status_dict
        if gs_status and gs_status.head and gs_status.head ~= "" then
            branch = gs_status.head
        end
    end

    -- Gather LSP Diagnostic Data
    local diag_str = ""
    if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

        local parts = {}
        if errors > 0 then
            table.insert(parts, "E:" .. errors)
        end
        if warnings > 0 then
            table.insert(parts, "W:" .. warnings)
        end

        if #parts > 0 then
            diag_str = table.concat(parts, " ")
        else
            diag_str = "OK"
        end
    end

    -- Gather Clean File Name (%t is native shorthand for tail filename)
    -- %m represents the modified state flag ([+])
    local file_str = vim.api.nvim_eval_statusline("%t %m", {}).str

    -- Assemble sections cleanly with structural pipe dividers
    local parts = {}
    table.insert(parts, " " .. mode_str)

    if branch ~= "" then
        table.insert(parts, " " .. branch)
    end

    if diag_str ~= "" then
        table.insert(parts, diag_str)
    end

    table.insert(parts, file_str .. " ")

    -- Join string segments together with a thin vertical divider
    return table.concat(parts, " - ")
end
