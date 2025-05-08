return {
	"github/copilot.vim",
	lazy = false,

	config = function()
		-- Disable default <Tab> mapping
		vim.g.copilot_no_tab_map = true

		-- Custom key mapping for accepting suggestion
		vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

		-- OPTIONAL: Map for navigating suggestions
		vim.api.nvim_set_keymap("i", "<C-K>", "copilot#Next()", { expr = true, silent = true })
		vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { expr = true, silent = true })

		-- OPTIONAL: Turn Copilot on/off
		vim.api.nvim_set_keymap("n", "<leader>cp", ":CopilotToggle<CR>", { silent = true })

        -- OPTIONAL: Set up a custom command to toggle Copilot
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
			["*"] = true, -- Enable for all filetypes
			markdown = true, -- Disable for markdown
			yaml = true, -- Disable for yaml
		}
	end,
}
