return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
        menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
            save_on_toggle = true,
        },
    },
    keys = function()
        local keys = {
            {
                "<leader>A",
                function()
                    require("harpoon"):list():add()
                end,
                desc = "Harpoon File",
            },
            {
                "H",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon Quick Menu",
            },
        }

        for i = 1, 5 do
            table.insert(keys, {
                "<A-" .. i .. ">",
                function()
                    require("harpoon"):list():select(i)
                end,
                desc = "Harpoon to File " .. i,
                mode = { "n", "i" },
            })
        end
        return keys
    end,
}
