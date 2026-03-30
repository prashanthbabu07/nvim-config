return {
    {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""
            vim.g.copilot_enabled = true -- Enable Copilot by default

            vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
            vim.api.nvim_set_keymap("i", "<C-J>", "<Plug>(copilot-accept-line)", {})
            vim.api.nvim_set_keymap("i", "<C-L>", "<Plug>(copilot-accept-word)", {})

            -- vim.api.nvim_set_keymap("i", "<C-;>", "copilog#Acc")

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
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
            options = {
                prompts = {
                    Rename = {
                        prompt = "Please rename the variable correctly in given selection based on context",
                        selection = function(source)
                            local copilot_select = require("CopilotChat.select")
                            return copilot_select.get_visual(source)
                            -- return copilot_select.visual(source)
                        end,
                    },
                    Typos = {
                        prompt = "Please fix the typos in the given selection",
                        selection = function(source)
                            local copilot_select = require("CopilotChat.select")
                            return copilot_select.get_visual(source)
                        end,
                    },
                    generate_csharp_xml_doc = {
                        prompt = [[
                COPILOT_REVIEW Review #buffer to "Generate C# XML documentation".

                CRITERIA:
                1. Analyze the code to identify classes, methods, properties, and other relevant code constructs that require documentation.
                2. Generate XML documentation comments for each identified construct, including summaries, parameter descriptions, and return value descriptions where applicable.
                3. Ensure that the generated documentation is clear, concise, and accurately reflects the functionality of the code.

                OUTPUT:
                - Provide ONLY the generated XML documentation comments for each relevant code construct.
                - Do NOT include any additional explanations, summaries, or suggestions; only provide the XML documentation.
        ]],

                        selection = function(source)
                            local copilot_select = require("CopilotChat.select")
                            return copilot_select.get_visual(source)
                        end,
                    },
                    suggest_method_names = {
                        prompt = "Please suggest method names for the given code selection based on its functionality",
                        selection = function(source)
                            local copilot_select = require("CopilotChat.select")
                            return copilot_select.get_visual(source)
                        end,
                    },
                },
            },
        },
        keys = {
            { "<leader>cpn", ":CopilotChat Rename<CR>", mode = "v", desc = "Rename the variable" },
            { "<leader>cpx", ":CopilotChat Typos<CR>", mode = "v", desc = "Fix Typos" },
            { "<leader>cpc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
            { "<leader>cpe", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
            { "<leader>cpr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
            { "<leader>cpf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
            { "<leader>cpo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
            { "<leader>cpd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
            { "<leader>cpt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
            { "<leader>cpm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
            { "<leader>cps", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
            {
                "<leader>cpg",
                ":CopilotChat generate_csharp_xml_doc<CR>",
                mode = "v",
                desc = "Generate C# XML documentation for the selected code",
            },
            {
                "<leader>cpo",
                ":CopilotChat suggest_method_names<CR>",
                mode = "v",
                desc = "Suggest method names for the selected code based on its functionality",
            },
        },
        config = function()
            require("CopilotChat").setup({})
        end,
    },
}
