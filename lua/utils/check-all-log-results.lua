local function check_all_log_results()
    -- 1. Use git ls-files to get only tracked .cs files.
    -- This handles .gitignore and excludes bin/obj automatically.
    local handle = io.popen("git ls-files '**/*.cs'")
    if not handle then
        return
    end
    local files_str = handle:read("*a")
    handle:close()

    local qf_list = {}
    local ns = vim.api.nvim_create_namespace("LogResultChecker")

    -- Split the output into a table of filenames
    local files = {}
    for s in files_str:gmatch("[^\r\n]+") do
        table.insert(files, s)
    end

    print("Scanning " .. #files .. " git-tracked files...")

    for _, file in ipairs(files) do
        -- Use pcall to catch errors if a file is unreadable
        local ok_read, lines = pcall(vim.fn.readfile, file)
        if ok_read then
            -- We parse the content as a string to avoid 'bufload' overhead/file limits
            local content = table.concat(lines, "\n")

            -- Create a temporary "scratch" parser for this content
            local parser = vim.treesitter.get_string_parser(content, "c_sharp")
            if parser then
                local tree = parser:parse()[1]
                local root = tree:root()
                local query = vim.treesitter.query.parse(
                    "c_sharp",
                    [[
          (invocation_expression
            function: (member_access_expression
              name: (identifier) @method (#eq? @method "LogResult"))
            arguments: (argument_list) @arg_list)
        ]]
                )

                for id, node in query:iter_captures(root, content) do
                    if query.captures[id] == "arg_list" then
                        local template_node = nil
                        local actual_params = 0
                        local child_count = node:named_child_count()

                        for i = 0, child_count - 1 do
                            local child = node:named_child(i)
                            if i == 1 then
                                template_node = (child:type() == "argument") and child:named_child(0) or child
                            elseif i > 1 then
                                actual_params = actual_params + 1
                            end
                        end

                        if template_node and template_node:type() == "string_literal" then
                            -- get_node_text on string parsers requires the raw content
                            local text = vim.treesitter.get_node_text(template_node, content)
                            local raw = text:gsub('^"?@?"', ""):gsub('"$', "")
                            local _, holes = raw:gsub("{[^{}]+}", "")

                            if holes ~= actual_params then
                                local s_row, s_col = template_node:range()
                                table.insert(qf_list, {
                                    filename = file,
                                    lnum = s_row + 1,
                                    col = s_col + 1,
                                    text = string.format("[LogResult] %d holes vs %d args", holes, actual_params),
                                    type = "E",
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    if #qf_list > 0 then
        vim.fn.setqflist(qf_list)
        vim.cmd("copen")
        print("Found " .. #qf_list .. " mismatches.")
    else
        print("Clean scan!")
    end
end

vim.api.nvim_create_user_command("CheckAllLogs", check_all_log_results, {})
