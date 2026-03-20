local prompts = require("copilotchat_prompts").prompts

vim.keymap.set("n", "<leader>cpi", function()
    require("CopilotChat").ask(prompts.contextual_inconsistency.prompt)
end, { desc = "Review buffer for Contextual Inconsistency" })

vim.keymap.set("n", "<leader>cpl", function()
    require("CopilotChat").ask(prompts.logging_inconsistency.prompt)
end, { desc = "Review buffer for Logging Inconsistency" })

-- vim.keymap.set("v", "<leader>cpg", function()
--     require("CopilotChat").ask(prompts.generate_csharp_xml_doc.prompt)
-- end, { desc = "Generate C# XML documentation for the given code" })

-- we need to xml to generate only for the selected code in visual mode;
-- vim.keymap.set("v", "<leader>cpg", function(source)
--     local selection = require("CopilotChat.select").get_visual(source)
--     local prompt = prompts.generate_csharp_xml_doc.prompt .. "\n\n" .. "Selected code:\n" .. selection
--     require("CopilotChat").ask(prompt)
-- end, { desc = "Generate C# XML documentation for the selected code" })
