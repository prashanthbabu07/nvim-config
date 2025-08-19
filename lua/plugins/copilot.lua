return {
    {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""
            vim.g.copilot_enabled = true -- Enable Copilot by default

            -- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
            vim.api.nvim_set_keymap("i", "<C-J>", "<Plug>(copilot-accept-line)", {})
            vim.api.nvim_set_keymap("i", "<C-L>", "<Plug>(copilot-accept-word)", {})

            vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { expr = true, silent = true })
            vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { expr = true, silent = true })

            vim.api.nvim_set_keymap("n", "<leader>cpt", ":CopilotToggle<CR>", { silent = true })
            vim.api.nvim_create_user_command("CopilotToggle", function()
                if vim.g.copilot_enabled then
                    vim.g.copilot_enabled = false
                    print("Copilot disabled")
                else
                    vim.g.copilot_enabled = true
                    print("Copilot enabled")
                end
            end, { desc = "Toggle GitHub Copilot" })

            -- You can also set global settings if needed
            vim.g.copilot_filetypes = {
                ["*"] = true,
                markdown = true,
                yaml = true,
            }
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        lazy = true,
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
        },
        build = "make tiktoken",         -- Only on MacOS or Linux
        opts = {
            options = {
                prompts = {
                    Rename = {
                        prompt = "Please rename the variable correctly in given selection based on context",
                        selection = function(source)
                            local copilot_select = require("CopilotChat.select")
                            return copilot_select.visual(source)
                        end,
                    },
                },
            },
        },
        keys = {
            { "<leader>cpn", ":CopilotChat Rename<CR>",  mode = "v", desc = "Rename the variable" },
            { "<leader>cpc", ":CopilotChat<CR>",         mode = "n", desc = "Chat with Copilot" },
            { "<leader>cpe", ":CopilotChatExplain<CR>",  mode = "v", desc = "Explain Code" },
            { "<leader>cpr", ":CopilotChatReview<CR>",   mode = "v", desc = "Review Code" },
            { "<leader>cpf", ":CopilotChatFix<CR>",      mode = "v", desc = "Fix Code Issues" },
            { "<leader>cpo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
            { "<leader>cpd", ":CopilotChatDocs<CR>",     mode = "v", desc = "Generate Docs" },
            { "<leader>cpt", ":CopilotChatTests<CR>",    mode = "v", desc = "Generate Tests" },
            { "<leader>cpm", ":CopilotChatCommit<CR>",   mode = "n", desc = "Generate Commit Message" },
            { "<leader>cps", ":CopilotChatCommit<CR>",   mode = "v", desc = "Generate Commit for Selection" },
        },
        config = function()
            require("CopilotChat").setup({})
        end,
    },
}
