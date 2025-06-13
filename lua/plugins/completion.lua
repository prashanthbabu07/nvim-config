return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        -- For luasnip users.
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            -- "hrsh7th/vim-vsnip",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            -- Set up nvim-cmp.
            local cmp = require("cmp")
            local ls = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body)     -- For `vsnip` users.
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ["<Tab>"] = cmp.mapping.select_next_item(),
                    -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    -- ["<Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     elseif ls.expand_or_jumpable() then
                    --         ls.expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    --
                    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     elseif ls.jumpable(-1) then
                    --         ls.jump(-1)
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    -- ["<Tab>"] = cmp.mapping.select_next_item(),
                    -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    -- ["<CR>"] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.confirm({ select = true })
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    {
                        name = "nvim_lsp",
                        priority = 1000,
                        entry_filter = function(entry, ctx)
                            -- Check if the completion came from your custom LSP
                            local kind = entry:get_kind()
                            -- Filter out 'Text' kinds — often irrelevant
                            -- return kind ~= cmp.lsp.CompletionItemKind.Text
                            return true
                        end,
                    },
                    { name = "luasnip",     priority = 750 }, -- For luasnip users.
                    {
                        name = "buffer",
                        priority = 250,
                        entry_filter = function(entry, _)
                            -- Only allow alphanumeric buffer words (no weird `ta i` or similar)
                            return entry:get_insert_text():match("^%w+$")
                        end,
                    },
                    { name = "path",        priority = 500 },
                    { name = "easy-dotnet", priority = 1000 },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sorting = {
                    priority_weight = 2,
                    -- comparators = {
                    --     cmp.config.compare.offset,
                    --     cmp.config.compare.exact,
                    --     cmp.config.compare.score,
                    --     -- Puts LSP and snippets first
                    --     function(entry1, entry2)
                    --         local kind_order = {
                    --             ["nvim_lsp"] = 1,
                    --             ["luasnip"] = 2,
                    --             ["buffer"] = 4,
                    --             ["path"] = 3,
                    --         }
                    --
                    --         local kind1 = kind_order[entry1.source.name] or 100
                    --         local kind2 = kind_order[entry2.source.name] or 100
                    --
                    --         if kind1 ~= kind2 then
                    --             return kind1 < kind2
                    --         end
                    --     end,
                    --
                    --     -- 👇 Deduplicate identical labels by preferring certain sources
                    --     -- function(entry1, entry2)
                    --     --     if entry1.completion_item.label == entry2.completion_item.label then
                    --     --         local priority = {
                    --     --             nvim_lsp = 1,
                    --     --             luasnip = 2,
                    --     --             buffer = 3,
                    --     --             path = 4,
                    --     --         }
                    --     --         local p1 = priority[entry1.source.name] or 100
                    --     --         local p2 = priority[entry2.source.name] or 100
                    --     --         return p1 < p2
                    --     --     end
                    --     -- end,
                    --
                    --     cmp.config.compare.kind,
                    --     cmp.config.compare.sort_text,
                    --     cmp.config.compare.length,
                    --     cmp.config.compare.order,
                    -- },
                },
            })

            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                else
                    return "<Tab>"
                end
            end, { expr = true, silent = true })

            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                else
                    return "<S-Tab>"
                end
            end, { expr = true, silent = true })
        end,
    },
}
