return {
    "GustavEikaas/easy-dotnet.nvim",
    -- commit = "50e3d11c16ef80df475e0c92248cdc066bc9fc0a",
    -- commit = "8efdb59bf2c30be31d2ebf03d501494fe2d019f4",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
        local dotnet = require("easy-dotnet") -- .setup()
        dotnet.setup({
            test_runner = {
                ---@type "split" | "float" | "buf"
                viewmode = "float",
                enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
                noBuild = true,
                noRestore = true,
                mappings = {
                    run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
                    filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
                    debug_test = { lhs = "<leader>d", desc = "debug test" },
                    go_to_file = { lhs = "g", desc = "got to file" },
                    run_all = { lhs = "<leader>R", desc = "run all tests" },
                    run = { lhs = "<leader>r", desc = "run test" },
                    peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
                    expand = { lhs = "o", desc = "expand" },
                    expand_node = { lhs = "E", desc = "expand node" },
                    expand_all = { lhs = "-", desc = "expand all" },
                    collapse_all = { lhs = "W", desc = "collapse all" },
                    close = { lhs = "q", desc = "close testrunner" },
                    refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
                },
                --- Optional table of extra args e.g "--blame crash"
                additional_args = {},
            },
        })
    end,
}
