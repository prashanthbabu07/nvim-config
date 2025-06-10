local project_root = "/Volumes/Sandisk/Projects/Help/NodeJs/lsp-from-scratch"
local server_path = project_root .. "/server/src/server.ts"
local ts_node = project_root .. "/node_modules/.bin/ts-node"

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.start({
    name = "lsp_from_scratch",
    cmd = {
        "npx",
        ts_node,
        server_path,
    },
    root_dir = project_root,
    capabilities = capabilities,
})

-- local configs = require("lspconfig.configs")
-- local project_root = "/Volumes/Sandisk/Projects/Help/NodeJs/lsp-from-scratch"
-- local server_path = project_root .. "/server/src/server.ts"
-- local ts_node = project_root .. "/node_modules/.bin/ts-node"
-- if not configs.lsp_from_scratch then
--     configs.lsp_from_scratch = {
--         default_config = {
--             cmd = { "npx", ts_node, server_path },
--             filetypes = { "text" }, -- or your desired filetypes
--             root_dir = function(fname)
--                 return project_root
--                 -- return vim.fn.getcwd() -- or use lspconfig.util.root_pattern("tsconfig.json")
--             end,
--             settings = {},
--         },
--     }
-- end
-- lspconfig.lsp_from_scratch.setup({
--     capabilities = capabilities,
--     on_attach = function(client, bufnr)
--         print("Custom LSP attached")
--         -- your keymaps or logic here
--     end,
-- })
