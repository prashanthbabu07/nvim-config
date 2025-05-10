local function rebuild_project(co, path)
    local spinner = require("easy-dotnet.ui-modules.spinner").new()
    spinner:start_spinner("Building")
    vim.fn.jobstart(string.format("dotnet build %s", path), {
        on_exit = function(_, return_code)
            if return_code == 0 then
                spinner:stop_spinner("Built successfully")
            else
                spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                error("Build failed")
            end
            coroutine.resume(co)
        end,
    })
    coroutine.yield()
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "leoluz/nvim-dap-go",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dotnet = require("easy-dotnet")

        require("dapui").setup()
        require("dap-go").setup()

        local debugger_command

        -- Check the operating system
        if vim.fn.has("mac") == 1 then
            debugger_command = "/usr/local/share/dotnet/netcoredbg/netcoredbg"
        elseif vim.fn.has("unix") == 1 then
            debugger_command = "/opt/tools/bin/netcoredbg"
        else
            print("Unsupported OS")
        end

        local function file_exists(path)
            local stat = vim.loop.fs_stat(path)
            return stat and stat.type == "file"
        end

        local debug_dll = nil

        local function ensure_dll()
            if debug_dll ~= nil then
                return debug_dll
            end
            local dll = dotnet.get_debug_dll()
            debug_dll = dll
            return dll
        end

        -- This is used where we had to manually set the path to the dll
        -- dap.configurations.cs = {
        --     {
        --         type = "coreclr",
        --         name = "launch - netcoredbg",
        --         request = "launch",
        --         program = function()
        --             return vim.fn.input("Path to dll", vim.fn.getcwd() .. "", "file")
        --         end,
        --     },
        -- }
        --

        -- C# and F# debugging
        for _, value in ipairs({ "cs", "fsharp" }) do
            dap.configurations[value] = {
                {
                    type = "coreclr",
                    name = "Program",
                    request = "launch",
                    env = function()
                        local dll = ensure_dll()
                        local vars = dotnet.get_environment_variables(dll.project_name, dll.absolute_project_path)
                        return vars or nil
                    end,
                    program = function()
                        local dll = ensure_dll()
                        local co = coroutine.running()
                        rebuild_project(co, dll.project_path)
                        if not file_exists(dll.target_path) then
                            error("Project has not been built, path: " .. dll.target_path)
                        end
                        return dll.target_path
                    end,
                    cwd = function()
                        local dll = ensure_dll()
                        return dll.absolute_project_path
                    end,
                },
            }

            dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
                debug_dll = nil
            end

            dap.adapters.coreclr = {
                type = "executable",
                command = debugger_command,
                args = { "--interpreter=vscode" },
            }
        end
        -- C# and F# debugging end

        -- Rust debugging
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.configurations.rust = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                -- runInTerminal = false,
            },
        }
        -- Rust debugging end

        -- Python debugging
        require("mason-nvim-dap").setup({
            ensure_installed = { "python" }, -- auto-installs debugpy
        })

        dap.adapters.python = {
            type = "executable",
            command = vim.fn.exepath("python3"),
            args = { "-m", "debugpy.adapter" },
        }
        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    return vim.fn.exepath("python3")
                end,
            },
        }

        -- Python debuggin end

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
        vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "red", linehl = "", numhl = "" })
        -- vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
    end,
}
