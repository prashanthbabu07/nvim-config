return {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- 1. Tell lazy.nvim to compile/bundle the binary locally
    -- build = "vfn=expand('bundled_build.lua')",
    config = function()
        require("mcphub").setup({
            -- 2. Force the plugin to prioritize its own bundled executable
            -- use_bundled_binary = true,
            config_path = vim.fn.expand("~/.config/mcp/mcp.json"),
        })
    end,
}
