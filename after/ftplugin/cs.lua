local function check_log_result_placeholders()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= "cs" then
        return
    end

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "c_sharp")
    if not ok or not parser then
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()
    local ns = vim.api.nvim_create_namespace("LogResultChecker")

    -- We find the call and the list of arguments
    local query_str = [[
    (invocation_expression
      function: (member_access_expression
        name: (identifier) @method_name (#eq? @method_name "LogResult"))
      arguments: (argument_list) @arg_list
    )
  ]]

    local query = vim.treesitter.query.parse("c_sharp", query_str)
    local diagnostics = {}

    -- Use iter_captures to directly get the node
    for id, node, _ in query:iter_captures(root, bufnr) do
        local name = query.captures[id]

        if name == "arg_list" then
            local template_node = nil
            local actual_params = 0

            -- Traverse children of the argument_list
            -- Named children in C# Tree-sitter for this list include every argument
            local child_count = node:named_child_count()

            for i = 0, child_count - 1 do
                local child = node:named_child(i)

                -- The extension method pattern: result.LogResult(logger, template, args...)
                if i == 1 then
                    -- This is the "template" argument
                    -- We need to drill down into the string_literal inside the argument
                    if child:type() == "argument" then
                        template_node = child:named_child(0)
                    else
                        template_node = child
                    end
                elseif i > 1 then
                    -- Everything after the template is a param
                    actual_params = actual_params + 1
                end
            end

            -- Validate the template
            if template_node and template_node:type() == "string_literal" then
                local template_text = vim.treesitter.get_node_text(template_node, bufnr)
                -- Clean up quotes for the count
                local raw_string = template_text:gsub('^"?@?"', ""):gsub('"$', "")
                local _, placeholder_count = raw_string:gsub("{[^{}]+}", "")

                if placeholder_count ~= actual_params then
                    local s_row, s_col, e_row, e_col = template_node:range()
                    table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = s_row,
                        col = s_col,
                        end_lnum = e_row,
                        end_col = e_col,
                        severity = vim.diagnostic.severity.ERROR,
                        message = string.format("Log Mismatch: %d holes vs %d args", placeholder_count, actual_params),
                        source = "LogResult Linter",
                    })
                end
            end
        end
    end

    vim.diagnostic.set(ns, bufnr, diagnostics)
end

-- Re-setup the autocmd for the current buffer
local group = vim.api.nvim_create_augroup("LogChecker", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
    group = group,
    pattern = "*.cs",
    callback = check_log_result_placeholders,
})


