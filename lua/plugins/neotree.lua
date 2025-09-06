-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
        default_component_configs = {
            -- icon = {
            -- folder_closed = "[+]",
            -- folder_open = "[-]",
            -- folder_empty = "[ ]",
            -- default = "•",
            -- },
        },
    },
    config = function()
        local neotree = require("neo-tree")
        neotree.setup({
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    never_show = { ".DS_Store", "thumbs.db" },
                },
                window = {
                    mappings = {
                        -- Make the mapping anything you want
                        ["E"] = "easy",
                        ["<space>"] = "none", -- disable default space mapping
                    },
                    width = 60,
                },
                follow_current_file = {
                    enabled = true,
                },
                use_libuv_file_watcher = true,
                commands = {
                    ["easy"] = function(state)
                        local node = state.tree:get_node()
                        local path = node.type == "directory" and node.path or vim.fs.dirname(node.path)
                        require("easy-dotnet").create_new_item(path, function()
                            require("neo-tree.sources.manager").refresh(state.name)
                        end)
                    end,
                },
            },
        })

        -- normal, visual, visual block
        vim.keymap.set(
            { "n", "v" },
            "<leader>fe",
            "<Esc>:Neotree toggle position=left<CR>",
            { noremap = true, silent = true }
        )
    end,
}
