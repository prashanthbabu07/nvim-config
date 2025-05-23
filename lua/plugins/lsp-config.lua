local function on_attach(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- print("LSP attached to buffer", bufnr, client.name)
    -- vim.notify("LSP " .. client.name .. " attached to buffer " .. bufnr)
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
            local noop = function() end -- Define noop function here

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
                handlers = {
                    -- fix from https://www.reddit.com/r/neovim/comments/1c4zu2n/unwanted_rust_analyzer_setup_by_masonlspconfig/
                    function(server_name)
                        -- Do nothing, as we're manually setting up all LSPs
                        -- require("lspconfig")[server_name].setup({}) -- This would be the default behavior
                    end,
                    -- Explicitly disable auto-setup for all servers you're configuring manually
                    -- ["lua_ls"] = function() end,
                    -- ["ts_ls"] = function() end,
                    -- ["rust_analyzer"] = function() end,
                    ["rust_analyzer"] = noop,
                    -- ["csharp_ls"] = function() end,
                    -- ["pyright"] = function() end,
                    -- ["ruff"] = function() end,
                    -- ["html"] = function() end,
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
        end,
    },
}
