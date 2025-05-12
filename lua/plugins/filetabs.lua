return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        vim.opt.termguicolors = true
        local bufferline = require("bufferline")
        bufferline.setup({
            options = {
                mode = "buffers", -- Display tab pages instead of buffers
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "left",
                        separator = true,
                    },
                },
                diagnostics = "nvim_lsp",  -- Optional: show LSP diagnostics in the tabline
                separator_style = "slant", -- Optional: choose your preferred separator style
                show_close_icon = false,   -- Optional: hide the close icon
                show_tab_indicators = true,
            },
        })

        --  Key mappings for bufferline
        vim.keymap.set("n", "<S-n>", ":BufferLineCycleNext<CR>", {})
        vim.keymap.set("n", "<S-p>", ":BufferLineCyclePrev<CR>", {})
    end,
}
