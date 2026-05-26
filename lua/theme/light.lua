local M = {}

function M.load()
    -- 1. Reset existing highlights
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "my_light"
    vim.o.background = "light"

    -- 2. Define your design palette (GitHub Light style values)
    local p = {
        bg = "#ffffff",       -- Editor background
        fg = "#24292e",       -- Normal text (Dark Gray)
        comment = "#6a737d",  -- Comments (Muted Gray)
        keyword = "#d73a49",  -- Keywords like public, async, return (Red)
        type = "#24292e",     -- Classes, Interfaces, Structs (Purple)
        func = "#24292e",     -- Methods and Functions (Blue)
        string = "#032f62",   -- Strings (Dark Blue)
        ident = "#e36209",    -- Variables and Parameters (Orange)
        gutter = "#ffffff",   -- Line number column background
        line_num = "#959da5", -- Line numbers color
        cursor = "#fafbfc",   -- Active line background highlighting

        -- NEW: Popup & Floating Window Layout Colors
        float_bg = "#ffffff",       -- Off-white background for windows/menus
        float_border = "#d1d5da",   -- Crisp, light-gray border lines
        float_select = "#e1e4e8",   -- Soft gray accent for highlighted menu items
        float_fg = "#24292e",       -- Foreground text inside popups
        float_title_bg = "#2278de", -- Title text for floating windows (matching keywords)
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
    hl("Operator", { fg = p.keyword })
    hl("PreProc", { fg = p.keyword })
    hl("Type", { fg = p.type, bold = false })
    hl("Structure", { fg = p.type, bold = false })

    -- 6. Modern Tree-sitter & LSP Overrides (The missing links!)
    hl("@keyword", { fg = p.keyword, bold = false })
    hl("@function", { fg = p.func })
    hl("@method", { fg = p.func })
    hl("@type", { fg = p.type })
    hl("@type.interface", { fg = p.type, bold = false }) -- Your C# interfaces!
    hl("@type.builtin", { fg = p.type })                 -- int, string, var
    hl("@variable", { fg = p.fg })
    hl("@parameter", { fg = p.ident })                   -- Input parameters
    hl("@property", { fg = p.fg })                       -- Object fields/properties
    hl("@string", { fg = p.string })
    hl("@comment", { fg = p.comment, italic = true })

    -- 7. Your customized minimalist folds from earlier
    hl("Folded", { fg = p.line_num, bg = "NONE", ctermbg = "NONE" })

    -- =========================================================================
    -- 2. NEW: Popup Menus (nvim-cmp / autocomplete lists)
    -- =========================================================================
    hl("Pmenu", { fg = p.float_fg, bg = p.float_bg })        -- Whole menu block
    hl("PmenuSel", { fg = p.float_fg, bg = p.float_select }) -- Active selected item
    hl("PmenuSbar", { bg = p.float_bg })                     -- Scrollbar track
    hl("PmenuThumb", { bg = p.float_border })                -- Scrollbar handle

    -- =========================================================================
    -- 3. NEW: Floating Windows (LSP Hover Docs, Diagnostics, Borders)
    -- =========================================================================
    hl("NormalFloat", { fg = p.float_fg, bg = p.float_bg })     -- Floating container text/bg
    hl("FloatBorder", { fg = p.float_border, bg = p.float_bg }) -- Window boundaries
    hl("FloatTitle", { fg = p.keyword, bold = false })          -- Title of floating blocks

    -- =========================================================================
    -- 4. NEW: Neo-tree Custom Floating Windows & Normal Overrides
    -- =========================================================================
    -- Force Neo-tree's floating borders and text to use your clean crisp palette
    hl("NeoTreeFloatingBorder", { fg = p.float_border, bg = p.float_bg })
    hl("NeoTreeNormalFloat", { fg = p.float_fg, bg = p.float_bg })

    -- Sync standard panel views (when Neo-tree is open on the left/right side)
    hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
    hl("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
    hl("NeoTreeWinSeparator", { fg = p.float_border, bg = p.bg })

    -- Optional clean adjustments for file states inside the Neo-tree sidebar
    hl("NeoTreeDirectoryName", { fg = p.fg, bold = false })
    hl("NeoTreeDirectoryIcon", { fg = p.fg })
    hl("NeoTreeRootName", { fg = p.keyword, bold = false })

    -- header background
    hl("NeoTreeTitleBar", { fg = p.float_bg, bg = p.float_title_bg, bold = true })

    -- =========================================================================
    -- 5. Window Separators (split & vsplit borders)
    -- =========================================================================
    -- WinSeparator is the modern highlight group for all split borders.
    -- We match it perfectly to your floating window borders.
    hl("WinSeparator", { fg = p.float_border, bg = "NONE" })

    -- Fallback safety for older Neovim structures or legacy plugins
    hl("VertSplit", { fg = p.float_border, bg = "NONE" })

    -- =========================================================================
    -- 6. Telescope Custom Layout Unification
    -- =========================================================================
    -- Panel Borders (Matching your floating windows)
    hl("TelescopeBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePromptBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopeResultsBorder", { fg = p.float_border, bg = p.bg })
    hl("TelescopePreviewBorder", { fg = p.float_border, bg = p.bg })

    -- Panel Titles (Prompt, Results, Preview)
    hl("TelescopePromptTitle", { fg = p.keyword, bold = false })
    hl("TelescopeResultsTitle", { fg = p.comment, bold = false })
    hl("TelescopePreviewTitle", { fg = p.func, bold = false })

    -- Active Line Selection & Icons inside the lists
    hl("TelescopeSelection", { bg = p.float_select })      -- Active list selection
    hl("TelescopeSelectionCaret", { fg = p.keyword })      -- The small indicator arrow
    hl("TelescopeMatching", { fg = p.func, bold = false }) -- Character matches while typing
end

return M
