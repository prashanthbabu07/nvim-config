local M = {}

function M.load()
    -- 1. Reset existing highlights
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "my_dark_dimmed_22272e"
    vim.o.background = "dark"

    -- 2. Define your design palette (GitHub Dark Dimmed Core Values)
    local p = {
        bg = "#22272e",       -- Your requested canvas background
        fg = "#adbac7",       -- Soft, muted silver-gray text (Low fatigue contrast)
        comment = "#768390",  -- Perfect ash-gray for comments
        keyword = "#f47067",  -- Dimmed coral/terracotta for keywords
        type = "#adbac7",     -- Types match normal text for structured reading
        func = "#adbac7",     -- Muted lilac/lavender for methods
        string = "#96d0ff",   -- Soft sky blue for strings
        ident = "#f69d50",    -- Muted clay/amber for parameters
        gutter = "#22272e",   -- Gutter matches your canvas seamless look
        line_num = "#545d68", -- Muted gray line numbers
        cursor = "#2d333b",   -- Active line highlighting (slightly lighter gray-blue)

        -- Popup & Floating Window Layout Colors (Stepped layout contrast)
        float_bg = "#2d333b",       -- Elevated, slightly lighter panel gray
        float_border = "#444c56",   -- Structured dark border lines
        float_select = "#373e47",   -- Active completion item block
        float_fg = "#adbac7",       -- Matching text for floating blocks
        float_title_bg = "#316dca", -- Muted classic blue for title headers
    }

    -- 3. Helper function to apply styles quickly
    local function hl(group, styles)
        vim.api.nvim_set_hl(0, group, styles)
    end

    -- 4. Standard UI Highlights
    hl("Normal", { fg = p.fg, bg = p.bg })
    hl("CursorLine", { bg = p.cursor })
    hl("LineNr", { fg = p.line_num, bg = p.gutter })
    hl("SignColumn", { bg = p.gutter })
    hl("Comment", { fg = p.comment, italic = true })
    hl("CursorLineNr", { fg = p.fg, bg = p.gutter, bold = false })

    -- 5. Core Native Syntax
    hl("Constant", { fg = p.string })
    hl("String", { fg = p.string })
    hl("Identifier", { fg = p.fg })
    hl("Function", { fg = p.func })
    hl("Statement", { fg = p.keyword, bold = false })
    hl("Operator", { fg = p.fg })
    hl("PreProc", { fg = p.keyword })
    hl("Type", { fg = p.type })
    hl("Structure", { fg = p.type })

    -- 6. Modern Tree-sitter & LSP Overrides
    hl("@keyword", { fg = p.keyword, bold = false })
    hl("@function", { fg = p.func })
    hl("@method", { fg = p.func })
    hl("@type", { fg = p.type })
    hl("@type.interface", { fg = p.type, bold = false })
    hl("@type.builtin", { fg = p.type })
    hl("@variable", { fg = p.fg })
    hl("@parameter", { fg = p.ident })
    hl("@property", { fg = p.fg })
    hl("@string", { fg = p.string })
    hl("@comment", { fg = p.comment, italic = true })

    -- 7. Customized minimalist folds
    hl("Folded", { fg = p.line_num, bg = "NONE", ctermbg = "NONE" })

    -- =========================================================================
    -- Popup Menus (nvim-cmp / autocomplete lists)
    -- =========================================================================
    hl("Pmenu", { fg = p.float_fg, bg = p.float_bg })
    hl("PmenuSel", { fg = p.float_fg, bg = p.float_select })
    hl("PmenuSbar", { bg = p.float_bg })
    hl("PmenuThumb", { bg = p.float_border })

    -- =========================================================================
    -- Floating Windows (LSP Hover Docs, Diagnostics, Borders)
    -- =========================================================================
    hl("NormalFloat", { fg = p.float_fg, bg = p.float_bg })
    hl("FloatBorder", { fg = p.float_border, bg = p.float_bg })
    hl("FloatTitle", { fg = p.keyword, bold = false })

    -- =========================================================================
    -- Neo-tree Custom Floating Windows & Normal Overrides
    -- =========================================================================
    hl("NeoTreeFloatingBorder", { fg = p.float_border, bg = p.float_bg })
    hl("NeoTreeNormalFloat", { fg = p.float_fg, bg = p.float_bg })

    -- Sync standard panel views
    hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
    hl("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
    hl("NeoTreeWinSeparator", { fg = p.float_border, bg = p.bg })

    -- File states inside the Neo-tree sidebar
    hl("NeoTreeDirectoryName", { fg = p.fg, bold = false })
    hl("NeoTreeDirectoryIcon", { fg = p.fg })
    hl("NeoTreeRootName", { fg = p.fg, bold = false })

    -- Header background
    hl("NeoTreeTitleBar", { fg = p.bg, bg = p.float_title_bg, bold = true })

    -- =========================================================================
    -- Window Separators (split & vsplit borders)
    -- =========================================================================
    hl("WinSeparator", { fg = p.float_border, bg = "NONE" })
    hl("VertSplit", { fg = p.float_border, bg = "NONE" })

    -- =========================================================================
    -- Telescope Custom Layout Unification
    -- =========================================================================
    hl("TelescopeBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePromptBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopeResultsBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePreviewBorder", { fg = p.float_border, bg = p.bg })

    hl("TelescopePromptTitle", { fg = p.keyword, bold = false })
    hl("TelescopeResultsTitle", { fg = p.comment, bold = false })
    hl("TelescopePreviewTitle", { fg = p.func, bold = false })

    hl("TelescopeSelection", { bg = p.float_select })
    hl("TelescopeSelectionCaret", { fg = p.keyword })
    hl("TelescopeMatching", { fg = p.func, bold = false })
end

return M
