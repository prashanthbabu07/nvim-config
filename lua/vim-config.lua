vim.opt.expandtab = true -- Tabs become spaces
vim.opt.shiftwidth = 4 -- Auto-indent uses 4 spaces
vim.opt.tabstop = 4 -- A tab is 4 spaces
vim.opt.softtabstop = 4 -- <Tab> inserts 4 spaces

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
    local filename = vim.fn.expand("%:t") -- Get the current file name
    local line = vim.fn.line(".") -- Get the current line number
    local text = filename .. ":" .. line -- Format as "filename:line"

    vim.fn.setreg("+", text) -- Copy to system clipboard
    print("Copied to clipboard: " .. text) -- Optional: Notify the user
end

vim.keymap.set("n", "<leader>cf", copy_filename_line, { desc = "Copy filename and line number" })

-- vim.api.nvim_create_user_command("TypoScan", function(opts)
--     local args = vim.split(opts.args, "%s+", { trimempty = true })
--     local dir = args[1] or "src"
--     local ext = args[2] or "cs"
--
--     print("Scanning " .. dir .. " for ." .. ext .. " typos...")
--
--     -- cspell flags:
--     -- --words-only: just the typos
--     -- --no-progress: cleaner output
--     -- --no-summary: don't show the "Found X errors" text
--     local cmd = string.format('cspell "%s/**/*.%s" --no-progress --no-summary', dir, ext)
--
--     local output = vim.fn.system(cmd)
--
--     if output == "" or output == nil then
--         print("No typos found!")
--         vim.cmd("cclose")
--     else
--         -- Load output into quickfix
--         -- cspell output is naturally formatted for quickfix (file:line:col - message)
--         vim.fn.setqflist({}, "r", { title = "CSpell Results", lines = vim.split(output, "\n") })
--         vim.cmd("copen")
--     end
-- end, {
--     nargs = "*",
--     complete = "dir",
--     desc = "Scan directory for typos using cspell",
-- })

vim.api.nvim_create_user_command("TypoScan", function(opts)
    local args = vim.split(opts.args, "%s+", { trimempty = true })
    local dir = args[1] or "src"
    local ext = args[2] or "cs"

    print("Scanning " .. dir .. " for ." .. ext .. " typos...")

    -- Run cspell
    local cmd = string.format('cspell "%s/**/*.%s" --no-progress --no-summary', dir, ext)
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

-- For init.lua
-- vim.opt.background = "light"
-- vim.cmd("colorscheme default")
-- vim.cmd("hi Normal guibg=#FFFFFF ctermbg=White")
local function file_class_name_scan(opts)
    local start_path = opts.fargs[1] or "."
    local extension = opts.fargs[2] or "cs"
    local mismatches = {}

    local function scan_dir(dir)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then
            return
        end

        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end
            local full_path = dir .. "/" .. name

            if type == "directory" then
                if name ~= "bin" and name ~= "obj" and name ~= ".git" then
                    scan_dir(full_path)
                end
            elseif type == "file" and name:match("%." .. extension .. "$") then
                -- Split filename by dots
                local parts = vim.fn.split(name, "\\.")
                local expected_class = parts[1]
                -- Extract sub-name if exists (e.g., 'Method' from 'Class.Method.cs')
                local expected_member = #parts > 2 and parts[2] or nil

                local f = io.open(full_path, "r")
                if f then
                    local content = f:read("*all")
                    f:close()

                    -- 1. Check Class/Type Name (Case-Sensitive)
                    -- Matches: class Name, interface Name, record Name, etc.
                    local _, class_name = string.match(content, "([%w]+)%s+(" .. expected_class .. ")%f[%W]")

                    if not class_name then
                        -- If we couldn't find the exact class name
                        table.insert(mismatches, {
                            filename = full_path,
                            lnum = 1,
                            text = string.format("❌ Class Mismatch: Expected '%s' (case-sensitive)", expected_class),
                        })
                        -- 2. Check Member/Method Name (Case-Sensitive)
                    elseif expected_member then
                        -- Escaping potential special characters in member name
                        local safe_member = expected_member:gsub("[%-%.%+%*%?%^%$%%]", "%%%1")
                        -- Look for the member name followed by non-word char (like '(' or ' ')
                        if not string.find(content, "%f[%w]" .. safe_member .. "%f[%W]") then
                            table.insert(mismatches, {
                                filename = full_path,
                                lnum = 1,
                                text = string.format(
                                    "⚠️ Member Mismatch: '%s' not found in content",
                                    expected_member
                                ),
                            })
                        end
                    end
                end
            end
        end
    end

    scan_dir(start_path)

    if #mismatches > 0 then
        vim.fn.setqflist(mismatches)
        vim.cmd("copen")
        print(string.format("Found %d mismatches.", #mismatches))
    else
        print("✅ Success: All files match Class.Method patterns.")
    end
end

vim.api.nvim_create_user_command("FileClassNameScan", file_class_name_scan, {
    nargs = "*",
    complete = "dir",
})
