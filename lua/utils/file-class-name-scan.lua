local function file_class_name_scan(opts)
    local start_path = opts.fargs[1] or "."
    local extension = opts.fargs[2] or "cs"
    local mismatches = {}

    local function scan_dir(dir)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then
            return
        end

        --if dir contains .Sdk then skip it
        if dir:find("%.Sdk") then
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
