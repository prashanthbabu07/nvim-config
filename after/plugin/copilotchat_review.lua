local prompts = require("copilotchat_prompts").prompts

vim.keymap.set("n", "<leader>cpi", function()
    require("CopilotChat").ask(prompts.contextual_inconsistency.prompt)
end, { desc = "Review buffer for Contextual Inconsistency" })

vim.keymap.set("n", "<leader>cpl", function()
    local buf_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    require("CopilotChat").ask(prompts.logging_inconsistency.prompt, { text = buf_contents })
end, { desc = "Review buffer for Logging Inconsistency" })

vim.keymap.set("n", "<leader>cps", function()
    local buf_contents = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    -- require("CopilotChat").ask(prompts.project_standards_review.prompt .. "\n\n" .. buf_contents)
    -- require("CopilotChat").ask(prompts.project_standards_review.prompt, { selection = buf_contents })
    require("CopilotChat").ask(prompts.project_standards_review.prompt .. "#buffer" )
end, { desc = "Reveiw Project standards" })

-- local select = require("CopilotChat.select")
-- require("CopilotChat").ask("Summarize this file #buffer")

-- vim.keymap.set("v", "<leader>cpg", function()
--     require("CopilotChat").ask(prompts.generate_csharp_xml_doc.prompt)
-- end, { desc = "Generate C# XML documentation for the given code" })

-- we need to xml to generate only for the selected code in visual mode;
-- vim.keymap.set("v", "<leader>cpg", function(source)
--     local selection = require("CopilotChat.select").get_visual(source)
--     local prompt = prompts.generate_csharp_xml_doc.prompt .. "\n\n" .. "Selected code:\n" .. selection
--     require("CopilotChat").ask(prompt)
-- end, { desc = "Generate C# XML documentation for the selected code" })
