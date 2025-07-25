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
                    prompt_title = "Find Files (glob supported)",
                    find_command = {
                        "fd",
                        "--type",
                        "f", --[["--hidden",]]
                        "--glob",
                    },
                })
            end, { desc = "Find files" })

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
