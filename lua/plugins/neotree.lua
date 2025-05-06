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
            icon = {
                folder_closed = "[+]",
                folder_open = "[-]",
                folder_empty = "[ ]",
                default = "•",
            },
        }
    },
	config = function()
        -- vim.api.nvim_set_hl(0, 'NeoTreeLine', { bg = 'none' })
		vim.keymap.set("n", "<C-n>", ":Neotree toggle reveal=true position=left<CR>", {})
	end,
}
