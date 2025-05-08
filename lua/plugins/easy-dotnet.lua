return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
        local dotnet = require("easy-dotnet")
        dotnet.setup({
            test_runner = {
                viewmode = "float",
                enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
                noBuild = true,
                noRestore = true,
            }
        })
    end,
}
