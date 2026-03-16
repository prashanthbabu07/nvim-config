local prompts = require("copilotchat_prompts").prompts

vim.keymap.set("n", "<leader>cpi", function()
    require("CopilotChat").ask(prompts.contextual_inconsistency.prompt)
end, { desc = "Review buffer for Contextual Inconsistency" })

vim.keymap.set("n", "<leader>cpl", function()
    require("CopilotChat").ask(prompts.logging_inconsistency.prompt)
end, { desc = "Review buffer for Logging Inconsistency" })
