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
                    "bashls",
                    "bicep",
                    "yamlls",
                    "angularls",
                },
                automatic_enable = {
                    "vimls",
                    "bicep",
                    "bashls",
                    "yamlls",
                    "angularls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "Decodetalkers/csharpls-extended-lsp.nvim",
        },
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = "all", -- "none" | "literals" | "all"
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypes = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
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
                            library = {
                                vim.api.nvim_get_runtime_file("", true),
                                vim.fn.stdpath("data") .. "/lazy",
                            },
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

            local csharpls_extended = require("csharpls_extended")

            lspconfig.csharp_ls.setup({
                -- cmd = { "csharp-ls" }, -- Ensure csharp-ls is in your PATH
                cmd = {
                    "dotnet",
                    "/Volumes/Sandisk/Projects/neovim-projects/csharp-language-server/src/CSharpLanguageServer/bin/Release/net9.0/CSharpLanguageServer.dll",
                },
                on_attach = on_attach,
                -- on_attach = function(client, bufnr)
                --     local opts = { buffer = bufnr }
                --     vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                -- end,
                root_dir = lspconfig.util.root_pattern("*.sln", ".git", "*.csproj"),
                handlers = {
                    ["textDocument/definition"] = csharpls_extended.handler,
                    ["textDocument/typeDefinition"] = csharpls_extended.handler,
                    -- Add any other handlers you might be using from csharpls-extended-lsp if needed
                    -- For example, for "show signature help" with markdown:
                    -- ["textDocument/signatureHelp"] = csharpls_extended.handler,
                    -- Refer to the plugin's documentation for all available handlers.
                },
            })
            csharpls_extended.buf_read_cmd_bind()

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

            -- bash
            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- angulre (LSP)
            lspconfig.angularls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "typescript", "html", "htmlangular" },
                root_dir = lspconfig.util.root_pattern("angular.json"), -- Detect Angular projects based on angular.json
            })

            vim.diagnostic.config({
                virtual_text = {
                    source = true, -- "always",
                    severity = { min = vim.diagnostic.severity.HINT },
                    format = function(diagnostic)
                        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
                    end,
                },
                float = {
                    source = true, -- "always",
                    border = "rounded",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- vim.keymap.set("n", "<leader>lsH", function()
            --     vim.lsp.buf.hover({
            --         border = "rounded",
            --     })
            -- end, { desc = "Hover" })
            vim.keymap.set({ "i", "n" }, "<C-h>", function()
                vim.lsp.buf.hover({
                    border = "rounded",
                })
            end, { desc = "Hover" })
            -- Autocommand to trigger hover with the mouse
            -- vim.o.updatetime = 500 -- in milliseconds
            -- vim.api.nvim_create_autocmd("CursorHold", {
            --     callback = function()
            --         local mode = vim.api.nvim_get_mode().mode
            --         local clients = vim.lsp.get_clients({ bufnr = 0 })
            --
            --         if mode == "n" and #clients > 0 then
            --             for _, client in pairs(clients) do
            --                 if client.supports_method("textDocument/hover") then
            --                     vim.lsp.buf.hover({ border = "rounded" })
            --                     break
            --                 end
            --             end
            --             -- vim.lsp.buf.hover({ border = "rounded" })
            --         end
            --     end,
            --     desc = "Show hover on mouse stop",
            -- })
            -- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertLeave" }, {
            --     callback = function()
            --         -- Close floating windows that are hover docs
            --         for _, win in ipairs(vim.api.nvim_list_wins()) do
            --             local config = vim.api.nvim_win_get_config(win)
            --             if config.relative ~= "" then
            --                 vim.api.nvim_win_close(win, true)
            --             end
            --         end
            --     end,
            --     desc = "Close LSP hover when moving cursor",
            -- })

            vim.keymap.set("n", "<leader>lsd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>lsD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set({ "n", "v" }, "<leader>lsc", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("n", "<leader>lsid", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
            -- vim.keymap.set('n', '<leader>lss', vim.diagnostic.set_loclist, { desc = 'Open diagnostic loclist' })

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
    {
        "prashanthbabu07/lsp-from-scratch",
        build = "npm install", -- install dependencies after cloning
        config = function()
            local lspconfig = require("lspconfig")
            local configs = require("lspconfig.configs")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Paths to the installed plugin and server file
            local plugin_path = vim.fn.stdpath("data") .. "/lazy/lsp-from-scratch"
            local ts_node = plugin_path .. "/node_modules/.bin/ts-node"
            local server_path = plugin_path .. "/server/src/server.ts"

            -- Define new LSP only if not already defined
            if not configs.lsp_from_scratch then
                configs.lsp_from_scratch = {
                    default_config = {
                        cmd = { ts_node, server_path },
                        filetypes = { "text" },    -- change to your target filetypes
                        root_dir = function()
                            return vim.fn.getcwd() -- or use lspconfig.util.root_pattern()
                        end,
                        settings = {},
                    },
                }
            end

            -- Setup the LSP
            lspconfig.lsp_from_scratch.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    print("✅ lsp-from-scratch attached")
                    -- Optional: set keymaps here
                end,
            })
        end,
        ft = { "text" }, -- or your actual target filetypes
        lazy = true,     -- set to true if you want it to load on demand
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        },
        -- or use config
        -- config = function(_, opts) require'lsp_signature'.setup({you options}) end
    },
}
