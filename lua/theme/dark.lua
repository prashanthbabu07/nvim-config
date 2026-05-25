local M = {}

function M.load()
    -- 1. Reset existing highlights
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "my_dark"
    vim.o.background = "dark"

    -- 2. Define your design palette (GitHub Dark style values)
    local p = {
        bg = "#1f2428", -- Core editor dark background
        fg = "#e1e4e8", -- Normal text (Light Gray/White)
        comment = "#6a737d", -- Comments (Muted Gray stays readable)
        keyword = "#f97583", -- Keywords like public, async, return (Muted Red)
        type = "#b392f0", -- Classes, Interfaces, Structs (Soft Purple)
        func = "#79b8ff", -- Methods and Functions (Bright Blue)
        string = "#9ecbff", -- Strings (Light Ice Blue)
        ident = "#ffab70", -- Variables and Parameters (Soft Orange)
        gutter = "#1f2428", -- Line number column background matching editor
        line_num = "#444d56", -- Line numbers color (Subtle dark gray)
        cursor = "#2b3036", -- Active line background highlighting

        -- Popup & Floating Window Layout Colors
        float_bg = "#24292e", -- Slightly offset lighter charcoal for menus/cards
        float_border = "#444d56", -- Crisp, mid-gray border lines
        float_select = "#39414a", -- Distinct accent gray for highlighted menu items
        float_fg = "#e1e4e8", -- Foreground text inside popups
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

    -- 5. Core Native Syntax
    hl("Constant", { fg = p.string })
    hl("String", { fg = p.string })
    hl("Identifier", { fg = p.fg })
    hl("Function", { fg = p.func })
    hl("Statement", { fg = p.keyword, bold = false })
    hl("Operator", { fg = p.keyword })
    hl("PreProc", { fg = p.keyword })
    hl("Type", { fg = p.type })
    hl("Structure", { fg = p.type })

    -- 6. Modern Tree-sitter & LSP Overrides
    hl("@keyword", { fg = p.keyword, bold = false })
    hl("@function", { fg = p.func })
    hl("@method", { fg = p.func })
    hl("@type", { fg = p.type })
    hl("@type.interface", { fg = p.type, bold = false }) -- Your C# interfaces!
    hl("@type.builtin", { fg = p.type }) -- int, string, var
    hl("@variable", { fg = p.fg })
    hl("@parameter", { fg = p.ident }) -- Input parameters
    hl("@property", { fg = p.fg }) -- Object fields/properties
    hl("@string", { fg = p.string })
    hl("@comment", { fg = p.comment, italic = true })

    -- 7. Your customized minimalist folds
    hl("Folded", { fg = p.line_num, bg = "NONE", ctermbg = "NONE" })

    -- =========================================================================
    -- 2. Popup Menus (nvim-cmp / autocomplete lists)
    -- =========================================================================
    hl("Pmenu", { fg = p.float_fg, bg = p.float_bg }) -- Whole menu block
    hl("PmenuSel", { fg = p.float_fg, bg = p.float_select }) -- Active selected item
    hl("PmenuSbar", { bg = p.float_bg }) -- Scrollbar track
    hl("PmenuThumb", { bg = p.float_border }) -- Scrollbar handle

    -- =========================================================================
    -- 3. Floating Windows (LSP Hover Docs, Diagnostics, Borders)
    -- =========================================================================
    hl("NormalFloat", { fg = p.float_fg, bg = p.float_bg }) -- Floating container text/bg
    hl("FloatBorder", { fg = p.float_border, bg = p.float_bg }) -- Window boundaries
    hl("FloatTitle", { fg = p.keyword, bold = true }) -- Title of floating blocks

    -- =========================================================================
    -- 4. Neo-tree Custom Floating Windows & Normal Overrides
    -- =========================================================================
    hl("NeoTreeFloatingBorder", { fg = p.float_border, bg = p.float_bg })
    hl("NeoTreeNormalFloat", { fg = p.float_fg, bg = p.float_bg })

    -- Sync standard panel views
    hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
    hl("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
    hl("NeoTreeWinSeparator", { fg = p.float_border, bg = p.bg })

    -- Optional clean adjustments for file states inside the Neo-tree sidebar
    hl("NeoTreeDirectoryName", { fg = p.func, bold = true })
    hl("NeoTreeDirectoryIcon", { fg = p.func })
    hl("NeoTreeRootName", { fg = p.keyword, bold = true })

    -- =========================================================================
    -- 5. Window Separators (split & vsplit borders)
    -- =========================================================================
    hl("WinSeparator", { fg = p.float_border, bg = "NONE" })
    hl("VertSplit", { fg = p.float_border, bg = "NONE" })

    -- =========================================================================
    -- 6. Telescope Custom Layout Unification
    -- =========================================================================
    hl("TelescopeBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePromptBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopeResultsBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePreviewBorder", { fg = p.float_border, bg = p.bg })

    -- Panel Titles
    hl("TelescopePromptTitle", { fg = p.keyword, bold = true })
    hl("TelescopeResultsTitle", { fg = p.comment, bold = true })
    hl("TelescopePreviewTitle", { fg = p.func, bold = true })

    -- Active Line Selection & Icons inside the lists
    hl("TelescopeSelection", { bg = p.float_select })
    hl("TelescopeSelectionCaret", { fg = p.keyword })
    hl("TelescopeMatching", { fg = p.func, bold = true })
end

return M
