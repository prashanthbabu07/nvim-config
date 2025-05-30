local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, silent = true, noremap = true }

    -- Example keymap: rename with <F2>
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

    -- Enable inlay hints if supported
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Setup code lens refresh if supported
    if client.server_capabilities.codeLensProvider then
        -- Initial refresh
        vim.lsp.codelens.refresh()

        -- Refresh on events
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end
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
        "VidocqH/lsp-lens.nvim",
        event = "LspAttach",
        config = function()
            require("lsp-lens").setup()
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
                    "omnisharp", -- this is for razor sharp only
                    "pyright",
                    "ruff",
                    "html",
                    "vimls",
                    -- "codelldb",
                    "clangd",
                },
                automatic_enable = {
                    "vimls",
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
                filetypes = { "cshtml", "html" },
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
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

            -- lspconfig.omnisharp.setup({
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     cmd = {
            --         vim.fn.stdpath("data") .. "/mason/bin/omnisharp",
            --         "--languageserver",
            --     },
            --     filetypes = { "cshtml" },
            --     root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
            -- })

            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            enable = true,
                        },
                        inlayHints = {
                            typeHints = { enable = true },
                            parameterHints = { enable = true },
                        },
                        diagnostics = {
                            enable = true,
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

            -- C & C++ (LSP)
            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
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

            -- vim.api.nvim_create_autocmd("LspAttach", {
            --     group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            --     callback = function(args)
            --         local client = vim.lsp.get_client_by_id(args.data.client_id)
            --         local bufnr = args.buf
            --         on_attach(client, bufnr)
            --     end,
            -- })

            vim.keymap.set("n", "<leader>lsih", function()
                local bufnr = vim.api.nvim_get_current_buf()
                -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
                -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
            end, { desc = "Toggle Inlay Hints" })

            vim.keymap.set("n", "<leader>lsl", vim.lsp.codelens.refresh, { desc = "Refresh CodeLens" })
        end,
    },
}
