-- https://github.com/nvim-telescope/telescope.nvim

return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    -- cwd_only = true,
                    -- Use fd as the finder with basic flags
                    find_command = {
                        "fd",
                        "--type",
                        "f" --[[, "--hidden"]],
                    },
                    file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
                },
            })

            vim.keymap.set("n", "<leader>ff", function()
                builtin.find_files({
                    cwd_only = true,
                    prompt_title = "Find Files (glob supported)",
                    find_command = {
                        "fd",
                        "--type",
                        "f", --[["--hidden",]]
                        "--case-sensitive",
                        "--glob",
                    },
                })
            end, { desc = "Find files" })

            vim.keymap.set("n", "<leader>fx", function()
                require("telescope.builtin").find_files({
                    prompt_title = "Find Files (Literal Sequence)",
                    -- 1. Remove find_command to use default Telescope/Vim logic
                    find_command = nil,

                    -- 2. THIS IS THE KEY: Use the substring matcher instead of fuzzy
                    -- It only matches if the characters are in the exact order (sequence)
                    sorter = require("telescope.sorters").get_substr_matcher(),

                    -- 3. Force case sensitivity
                    case_mode = "respect_case",
                })
            end, { desc = "Find files (Exact Sequence)" })

            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "File grep" })
            vim.keymap.set("n", "<leader>fnf", function()
                builtin.find_files({
                    prompt_title = "Find Notes",
                    cwd = "~/notes",
                    find_command = {
                        "fd",
                        "--type",
                        "f", --[["--hidden",]]
                        "--glob",
                    },
                })
            end, { desc = "Find notes" })
            vim.keymap.set("n", "<leader>fng", function()
                builtin.live_grep({
                    prompt_title = "Grep Notes",
                    cwd = "~/notes",
                })
            end, { desc = "Find grep notes" })

            vim.keymap.set("n", "<leader>fr", function()
                builtin.oldfiles({ cwd_only = true })
            end, { desc = "Recent files" })

            -- vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {})
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            -- This is your opts table
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
