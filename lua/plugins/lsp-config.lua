local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "rust_analyzer",
                    "csharp_ls",
                    "pyright",
                    "ruff",
                    "html",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.html.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                -- on_attach = function(client, bufnr)
                --     local opts = { buffer = bufnr }
                --     vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                -- end,
            })

            lspconfig.csharp_ls.setup({
                cmd = { "csharp-ls" }, -- Ensure csharp-ls is in your PATH
                on_attach = on_attach,
                -- on_attach = function(client, bufnr)
                --     local opts = { buffer = bufnr }
                --     vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                -- end,
                root_dir = lspconfig.util.root_pattern("*.sln", ".git", "*.csproj"),
            })

            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            enable = false, -- 🔧 Disable to avoid duplicate rustc diagnostics
                        },
                    },
                },
            })

            -- PYRIGHT: LSP
            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- disable pyright formatting
                    client.server_capabilities.documentFormattingProvider = false
                end,
            })

            -- RUFF (the new LSP)
            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- optional: disable hover to let pyright handle it
                    client.server_capabilities.hoverProvider = false
                end,
                init_options = {
                    settings = {
                        args = { "--no-dupes" }, -- you can pass custom ruff args here if needed
                        -- args = {},
                    },
                },
            })

            vim.diagnostic.config({
                virtual_text = {
                    source = "always",
                    severity = { min = vim.diagnostic.severity.HINT },
                    format = function(diagnostic)
                        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
                    end,
                },
                float = {
                    source = "always",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            vim.keymap.set("n", "<leader>lsH", function()
                vim.lsp.buf.hover({
                    border = "rounded",
                })
            end, { desc = "Hover" })
            vim.keymap.set("n", "<leader>lsd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>lsD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set({ "n", "v" }, "<leader>lsc", vim.lsp.buf.code_action, { desc = "Code action" })
            -- vim.keymap.set({ "n", "v" }, "<leader>ld", function()
            --     vim.diagnostic.open_float({
            --         border = "rounded",
            --     })
            -- end, { desc = "Show diagnostics" })
            vim.keymap.set("n", "<leader>lsh", function()
                vim.lsp.buf.signature_help({
                    border = "rounded",
                })
            end, { desc = "Signature help" })

            vim.keymap.set(
                "n",
                "<leader>lsr",
                require("telescope.builtin").lsp_references,
                { desc = "Find references (Telescope)" }
            )
        end,
    },
}
