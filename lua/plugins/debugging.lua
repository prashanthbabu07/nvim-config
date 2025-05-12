return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<Leader>B", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
        vim.keymap.set("n", "<F10>", function()
            require("dap").step_over()
        end, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", function()
            require("dap").step_into()
        end, { desc = "Step Into" })

        -- breakpoint character for visual queue
        vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "red", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🔴", texthl = "red", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "red", linehl = "", numhl = "" })
        -- vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
    end,
}
