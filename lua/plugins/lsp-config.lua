return {
    -- Combine Mason and Mason-lspconfig into one unified block to avoid double setups
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        lazy = false,
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
                    -- "csharp_ls",
                    -- "omnisharp",
                    "pyright",
                    "pyrefly",
                    "ruff",
                    "html",
                    "vimls",
                    "clangd",
                    "bashls",
                    "bicep",
                    "yamlls",
                    "angularls",
                    "vacuum",
                    "zls",
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

            -- TS / JS
            vim.lsp.config.ts_ls = {
                capabilities = capabilities,
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = "all",
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

            -- HTML
            vim.lsp.config.html = {
                capabilities = capabilities,
                filetypes = { "cshtml", "html" },
            }
            vim.lsp.enable({ "html" })

            -- Lua
            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
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
            }
            vim.lsp.enable({ "lua_ls" })

            -- Rust
            vim.lsp.config.rust_analyzer = {
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = { enable = true },
                        inlayHints = {
                            typeHints = { enable = true },
                            parameterHints = { enable = true },
                        },
                        diagnostics = { enable = true },
                    },
                },
            }
            vim.lsp.enable({ "rust_analyzer" })

            -- Pyright
            vim.lsp.config.pyright = {
                capabilities = capabilities,
                on_attach = function(client, _)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            }
            vim.lsp.enable({ "pyright" })

            -- PYREFLY (The new Rust-based type-checker & LSP)
            vim.lsp.config.pyrefly = {
                cmd = { "pyrefly", "lsp" },
                filetypes = { "python" },
                capabilities = capabilities,
                root_markers = { "pyrefly.toml", "pyproject.toml", "setup.py", ".git" },
                -- If you want Pyrefly to only do type-checking and let Ruff handle hover docs:
                -- init_options = {
                --     ["python.pyrefly.disableLanguageServices"] = false,
                -- }
            }
            vim.lsp.enable({ "pyrefly" })

            -- Ruff
            vim.lsp.config.ruff = {
                capabilities = capabilities,
                on_attach = function(client, _)
                    client.server_capabilities.hoverProvider = false
                end,
                init_options = {
                    settings = {
                        args = { "--no-dupes" },
                    },
                },
            }
            vim.lsp.enable({ "ruff" })

            -- C / C++
            vim.lsp.config.clangd = {
                cmd = { "clangd", "--background-index" },
                capabilities = capabilities,
                filetypes = { "c", "cpp" },
            }
            vim.lsp.enable({ "clangd" })

            -- Bash
            vim.lsp.config.bashls = {
                capabilities = capabilities,
                filetypes = { "sh", "bash", "zsh" },
            }
            vim.lsp.enable({ "bashls" })

            -- Angular
            vim.lsp.config.angularls = {
                capabilities = capabilities,
                filetypes = { "typescript", "html", "htmlangular" },
                root_markers = { "angular.json" },
            }
            vim.lsp.enable({ "angularls" })

            -- OpenAPI / Vacuum
            vim.lsp.config.vacuum = {
                capabilities = capabilities,
                filetypes = { "yaml", "json" },
                root_markers = { ".git" },
            }
            vim.lsp.enable({ "vacuum" })

            -- VimL
            vim.lsp.config.vimls = {
                capabilities = capabilities,
                root_markers = { ".git" },
            }
            vim.lsp.enable({ "vimls" })

            -- Zig
            vim.lsp.config.zls = {
                capabilities = capabilities,
                cmd = { "zls" },
                filetypes = { "zig" },
                root_markers = { ".git" },
            }
            vim.lsp.enable({ "zls" })

            vim.lsp.config.mojo = {
                cmd = { "mojo-lsp-server" },
                filetypes = { "mojo", "python" },
                root_markers = { "mojo.toml", "pyproject.toml", ".git" },
                capabilities = capabilities,
            }
            vim.lsp.enable({ "mojo" })

            -- Diagnostics Configuration
            vim.diagnostic.config({
                virtual_text = {
                    source = true,
                    severity = { min = vim.diagnostic.severity.HINT },
                },
                float = {
                    source = true,
                    border = "rounded",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Keymaps
            vim.keymap.set({ "i", "n" }, "<C-h>", function()
                vim.lsp.buf.hover({ border = "rounded" })
            end, { desc = "Hover" })

            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
            vim.lsp.inlay_hint.enable(false)
            vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { desc = "Code action" })
            vim.keymap.set("n", "<leader>lid", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

            vim.keymap.set("n", "<leader>lh", function()
                vim.lsp.buf.signature_help({ border = "rounded" })
            end, { desc = "Signature help" })

            vim.keymap.set(
                "n",
                "<leader>lr",
                require("telescope.builtin").lsp_references,
                { desc = "Find references (Telescope)" }
            )
            vim.keymap.set(
                "n",
                "<leader>lX",
                require("telescope.builtin").diagnostics,
                { desc = "Telescope diagnostics" }
            )
            vim.keymap.set("n", "<leader>lx", function()
                require("telescope.builtin").diagnostics({ bufnr = 0 })
            end, { desc = "Telescope diagnostics (current buffer)" })

            vim.keymap.set("n", "<leader>lih", function()
                local bufnr = vim.api.nvim_get_current_buf()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
            end, { desc = "Toggle Inlay Hints" })
        end,
    },
}
