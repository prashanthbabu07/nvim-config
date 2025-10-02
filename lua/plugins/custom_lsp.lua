return {
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
                    filetypes = { "text" }, -- change to your target filetypes
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
        -- vim.lsp.enable({ "lsp_from_scratch" })
    end,
    ft = { "text" }, -- or your actual target filetypes
    lazy = true, -- set to true if you want it to load on demand
}
