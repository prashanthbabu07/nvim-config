--[[
documentation
    https://github.com/akinsho/bufferline.nvim/blob/main/doc/bufferline.txt
--]]

return {}

-- return {
--     "akinsho/bufferline.nvim",
--     dependencies = "nvim-tree/nvim-web-devicons",
--     config = function()
--         vim.opt.termguicolors = true
--         local bufferline = require("bufferline")
--         bufferline.setup({
--             options = {
--                 mode = "buffers", -- Display tab pages instead of buffers
--                 close_command = "bdelete! %d",
--                 numbers = "both", -- Show both buffer number and name
--                 -- style_preset = bufferline.style_preset.no_italic,
--                 offsets = {
--                     {
--                         filetype = "neo-tree",
--                         text = "File Explorer",
--                         text_align = "left",
--                         separator = true,
--                     },
--                 },
--                 diagnostics = "nvim_lsp", -- Optional: show LSP diagnostics in the tabline
--                 -- separator_style = "slant", -- Optional: choose your preferred separator style
--                 show_close_icon = true, -- Optional: hide the close icon
--                 show_tab_indicators = true,
--             },
--         })
--
--         --  Key mappings for bufferline
--         vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", {})
--         vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", {})
--     end,
-- }
