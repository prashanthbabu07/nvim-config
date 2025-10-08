-- local function on_attach(client, bufnr)
--     -- print("LSP root dir: " .. client.config.root_dir)
--     -- local opts = { buffer = bufnr, silent = true, noremap = true }
--
--     -- Example keymap: rename with <F2>
--     -- vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
--
--     -- Enable inlay hints if supported
--     -- if client.server_capabilities.inlayHintProvider then
--     --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
--     -- end
--
--     -- Setup code lens refresh if supported
--     if client.server_capabilities.codeLensProvider then
--         -- Initial refresh
--         vim.lsp.codelens.refresh()
--
--         -- Refresh on events
--         -- vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
--         --     buffer = bufnr,
--         --     callback = vim.lsp.codelens.refresh,
--         -- })
--     end
-- end

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
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
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
                    "vacuum",
                },
                automatic_enable = {
                    -- "vimls",
                    "bicep",
                    "bashls",
                    "yamlls",
                    "angularls",
                    "vacuum",
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

            vim.lsp.config.ts_ls = {
                capabilities = capabilities,
                -- on_attach = on_attach,
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
            }
            vim.lsp.enable({ "ts_ls" })

            vim.lsp.config.html = {
                capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "cshtml", "html" },
            }
            vim.lsp.enable({ "html" })

            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
                -- on_attach = on_attach,
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
            }
            vim.lsp.enable({ "lua_ls" })

            -- local csharpls_extended = require("csharpls_extended")

            -- vim.lsp.config.csharp_ls = {
            --     cmd = { "csharp-ls" }, -- Ensure csharp-ls is in your PATH
            --     -- cmd = {
            --     --     "dotnet",
            --     --     "/Volumes/Sandisk/Projects/neovim-projects/csharp-language-server/src/CSharpLanguageServer/bin/Release/net9.0/CSharpLanguageServer.dll",
            --     -- },
            --     -- on_attach = on_attach,
            --     capabilities = capabilities,
            --     -- on_attach = function(client, bufnr)
            --     -- --     local opts = { buffer = bufnr }
            --     -- --     vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
            --     -- end,
            --     -- root_dir = lspconfig.util.root_pattern(".git", "*.sln", ".git", "*.csproj"),
            --     -- root_dir = lspconfig.util.root_pattern(".root"),
            --     -- root_dir = function(fname)
            --     --     --root pattern to check from the directory nivm was opened from
            --     --     local cwd = vim.fn.getcwd(-1, -1)
            --     --     local root_marker = cwd .. "/.root"
            --     --     if vim.uv.fs_stat(root_marker) then
            --     --         return cwd
            --     --     end
            --     --
            --     --     return lspconfig.util.root_pattern(".git", "*.sln", ".csproj")(fname)
            --     -- end,
            --
            --     handlers = {
            --         ["textDocument/definition"] = csharpls_extended.handler,
            --         ["textDocument/typeDefinition"] = csharpls_extended.handler,
            --         -- Add any other handlers you might be using from csharpls-extended-lsp if needed
            --         -- For example, for "show signature help" with markdown:
            --         -- ["textDocument/signatureHelp"] = csharpls_extended.handler,
            --         -- Refer to the plugin's documentation for all available handlers.
            --     },
            -- }
            -- vim.lsp.enable({ "csharp_ls" })
            -- csharpls_extended.buf_read_cmd_bind()

            -- lspconfig.omnisharp.setup({
            --     capabilities = capabilities,
            --     -- on_attach = on_attach,
            --     cmd = {
            --         vim.fn.stdpath("data") .. "/mason/bin/omnisharp",
            --         "--languageserver",
            --     },
            --     filetypes = { "cshtml" },
            --     root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
            -- })
            -- local cmd = {
            --     "roslyn",
            --     "--stdio",
            --     "--logLevel=Information",
            --     "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            -- }
            -- vim.lsp.config("roslyn", {
            --     cmd = cmd,
            --     filetypes = { "cs", "vb" },
            --     capabilities = capabilities,
            --     settings = {
            --         ["csharp|code_lens"] = {
            --             dotnet_enable_references_code_lens = true,
            --         },
            --     },
            -- })
            -- vim.lsp.enable({ "roslyn" })

            vim.lsp.config.rust_analyzer = {
                capabilities = capabilities,
                -- on_attach = on_attach,
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
            }
            vim.lsp.enable({ "rust_analyzer" })

            -- PYRIGHT: LSP
            vim.lsp.config.pyright = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- disable pyright formatting
                    client.server_capabilities.documentFormattingProvider = false
                end,
            }
            vim.lsp.enable({ "pyright" })

            -- RUFF (the new LSP)
            vim.lsp.config.ruff = {
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
            }
            vim.lsp.enable({ "ruff" })

            -- C & C++ (LSP)
            vim.lsp.config.clangd = {
                cmd = { "clangd", "--background-index" },
                capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "c", "cpp" },
            }
            vim.lsp.enable({ "clangd" })

            -- bash
            vim.lsp.config.bashls = {
                capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "sh", "bash", "zsh" },
            }
            vim.lsp.enable({ "bashls" })

            -- angulre (LSP)
            vim.lsp.config.angularls = {
                capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "typescript", "html", "htmlangular" },
                root_dir = lspconfig.util.root_pattern("angular.json"), -- Detect Angular projects based on angular.json
            }
            vim.lsp.enable({ "angularls" })

            -- openapi spec (LSP)
            vim.lsp.config.vacuum = {
                capabilities = capabilities,
                -- on_attach = on_attach,
                filetypes = { "yaml", "json" }, -- Adjust filetypes as needed
                root_dir = lspconfig.util.root_pattern(".git"), -- Detect Vacuum projects based
            }
            vim.lsp.enable({ "vacuum" })

            -- vimls (LSP)
            vim.lsp.config.vimls = {
                capabilities = capabilities,
                -- on_attach = on_attach,
                root_dir = lspconfig.util.root_pattern(".git"),
            }
            vim.lsp.enable({ "vimls" })

            vim.diagnostic.config({
                virtual_text = {
                    source = true, -- "always",
                    severity = { min = vim.diagnostic.severity.HINT },
                    -- format = function(diagnostic)
                    --     return string.format("%s [%s]", diagnostic.message, diagnostic.source)
                    -- end,
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

            -- vim.keymap.set("n", "<leader>lH", function()
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

            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
            vim.lsp.inlay_hint.enable(true)
            vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("n", "<leader>lid", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
            -- vim.keymap.set('n', '<leader>ls', vim.diagnostic.set_loclist, { desc = 'Open diagnostic loclist' })

            -- vim.keymap.set({ "n", "v" }, "<leader>ld", function()
            --     vim.diagnostic.open_float({
            --         border = "rounded",
            --     })
            -- end, { desc = "Show diagnostics" })
            vim.keymap.set("n", "<leader>lh", function()
                vim.lsp.buf.signature_help({
                    border = "rounded",
                })
            end, { desc = "Signature help" })

            vim.keymap.set(
                "n",
                "<leader>lr",
                require("telescope.builtin").lsp_references,
                { desc = "Find references (Telescope)" }
            )

            -- telescope diagnostics
            vim.keymap.set(
                "n",
                "<leader>lx",
                require("telescope.builtin").diagnostics,
                { desc = "Telescope diagnostics" }
            )

            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
                callback = vim.lsp.codelens.refresh,
            })
            -- vim.api.nvim_create_autocmd("LspAttach", {
            --     group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            --     callback = function(args)
            --         local client = vim.lsp.get_client_by_id(args.data.client_id)
            --         local bufnr = args.buf
            --         on_attach(client, bufnr)
            --     end,
            -- })

            vim.keymap.set("n", "<leader>lih", function()
                local bufnr = vim.api.nvim_get_current_buf()
                -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
                -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
            end, { desc = "Toggle Inlay Hints" })

            vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.refresh, { desc = "Refresh CodeLens" })
        end,
    },
    -- {
    --     "seblyng/roslyn.nvim",
    --     opts = {
    --         -- your configuration goes here; leave empty for defaults
    --     },
    --     ft = { "cs", "vb" }, -- optional: load only for C#/VB files
    -- },
}
