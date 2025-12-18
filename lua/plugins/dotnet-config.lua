return {
    "GustavEikaas/easy-dotnet.nvim",
    -- commit = "50e3d11c16ef80df475e0c92248cdc066bc9fc0a",
    -- commit = "8efdb59bf2c30be31d2ebf03d501494fe2d019f4",
    commit = "8b7d97a61a323816754860dc6614f78400538b89",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
        local dotnet = require("easy-dotnet") -- .setup()
        dotnet.setup({
            lsp = {
                enabled = true,
                roslynator_enabled = true, -- Automatically enable roslynator analyzer
                analyzer_assemblies = {
                    vim.fn.expand("~/.config/nvim/analyzers/SonarAnalyzer.CSharp.dll"),
                },
                config = {},
            },
            test_runner = {
                ---@type "split" | "float" | "buf"
                -- viewmode = "float",
                viewmode = "buf",
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
            server = {
                ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
                log_level = "Off",
            },
        })

        -- key bindings pairs
        local dotnet_functions = {
            -- Testing
            { key = "<leader>dtt", func = dotnet.testrunner, desc = "Toggle test runner" },
            { key = "<leader>dtr", func = dotnet.testrunner_refresh, desc = "Refresh test runner" },
            { key = "<leader>dtb", func = dotnet.testrunner_refresh_build, desc = "Refresh test runner with build" },
            { key = "<leader>dts", func = dotnet.test_solution, desc = "Test solution" },

            -- Project
            { key = "<leader>dpv", func = dotnet.project_view, desc = "Project view" },
            { key = "<leader>dpd", func = dotnet.project_view_default, desc = "Project view default" },
            { key = "<leader>dpa", func = dotnet.add_package, desc = "Add package" },
            { key = "<leader>dna", func = dotnet.add_package, desc = "Add package" },
            { key = "<leader>dnr", func = dotnet.remove_package, desc = "Remove package" },

            -- Solution
            { key = "<leader>dss", func = dotnet.solution_select, desc = "Solution select" },
            { key = "<leader>dsa", func = dotnet.solution_add, desc = "Solution add" },
            { key = "<leader>dsr", func = dotnet.solution_remove, desc = "Solution remove" },

            -- Build
            { key = "<leader>dbp", func = dotnet.build, desc = "Build project" },
            { key = "<leader>dbs", func = dotnet.build_solution, desc = "Build solution" },
            { key = "<leader>dbqp", func = dotnet.build_quickfix, desc = "Build project quick fix" },
            { key = "<leader>dbqs", func = dotnet.build_solution_quickfix, desc = "Build solution quick fix" },
            { key = "<leader>dpc", func = dotnet.clean, desc = "Clean project" },
            { key = "<leader>dpr", func = dotnet.restore, desc = "Restore project" },

            -- Reset
            { key = "<leader>dr", func = dotnet.reset, desc = "Reset easy-dotnet" },
        }

        for _, mapping in ipairs(dotnet_functions) do
            vim.keymap.set("n", mapping.key, mapping.func, { desc = mapping.desc })
        end
    end,
}
