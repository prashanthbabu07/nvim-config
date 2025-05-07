return {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup({
            optons = {
                mode = "buffers",          -- Show buffer tabs
                diagnostics = "nvim_lsp",  -- Show LSP errors/warnings
                separator_style = "slant", -- Cool separator style
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true
                    }
                }
            }
        })

        vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", {})
        vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", {})
        vim.keymap.set("n", "<leader>c", ":BufferClose<CR>", {})
    end
}
