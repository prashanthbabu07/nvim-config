vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.statuscolumn = "%s%1l   "
-- vim.opt.relativenumber = true
vim.g.mapleader = " "
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			lazy = false, -- neo-tree will lazily load itself
			opts = {},
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				require("lspconfig").lua_ls.setup({})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
					},
				})
			end,
		}
		--[[ {
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup()
			end,
		} ]],
	},

	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
-- vim.keymap.set("n", "<C-m>", ":Neotree close<CR>", {})

vim.keymap.set("n", "<C-n>", ":Neotree toggle reveal=true position=left<CR>", {})

vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end, { desc = "Format current buffer" })

local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
	highlight = { enable = true },
	indent = { enable = true },
})

--[[local wk = require("which-key")

wk.setup({
  triggers = {"<leader>", "<C-s>", "<C-p>", "<C-n>"},  -- Customize trigger keys here
})

wk.register({
  ["<C-s>"] = { ":w<CR>", "Save File" },  -- Save File mapped to Ctrl+s
  ["<C-p>"] = { ":Telescope find_files<CR>", "Find Files" }, -- Ctrl+p to find files
  ["<C-n>"] = { ":Neotree toggle<CR>", "Toggle NeoTree" }, -- Ctrl+n to toggle NeoTree
}, { mode = "n", prefix = "<C>" })
]]

require("catppuccin").setup()
vim.cmd.colorscheme = "catppuccin"
