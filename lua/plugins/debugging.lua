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

local function dotnet_debugging_config(dap)
    local dotnet = require("easy-dotnet")
    local function file_exists(path)
        local stat = vim.loop.fs_stat(path)
        return stat and stat.type == "file"
    end

    for _, value in ipairs({ "cs", "fsharp" }) do
        local debug_dll = nil

        local function ensure_dll()
            if debug_dll ~= nil then
                return debug_dll
            end
            local dll = dotnet.get_debug_dll()
            debug_dll = dll
            return dll
        end
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
            command = "netcoredbg",
            args = { "--interpreter=vscode" },
        }
    end
end

local function rust_debugging_config(dap)
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
                return vim.fn.input({
                    prompt = "Path to executable: ",
                    default = vim.fn.getcwd() .. "/target/debug/",
                    completion = "file",
                })
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            -- runInTerminal = false,
        },
    }
end

local function python_debugging_config(dap)
    require("mason-nvim-dap").setup({
        automatic_installation = true,
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
end

local function clang_debugging_config(dap)
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            args = { "--port", "${port}" },
        },
    }

    dap.configurations.c = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input({
                    prompt = "Path to executable: ",
                    default = vim.fn.getcwd() .. "/a.out",
                    completion = "file",
                })
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            args = {},
        },
    }

    dap.configurations.cpp = dap.configurations.c -- C++ uses the same config
end

local function js_debugging_config(dap)
    require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = { "js-debug-adapter" }, -- auto-installs js-debug-adapter
    })

    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                vim.fs.normalize(vim.fn.stdpath("data"))
                .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}",
            },
        },
    }

    dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}", -- ✅ works when passed to both
        executable = {
            command = "node",
            args = {
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}", -- ✅ will be replaced
            },
        },
    }

    for _, language in ipairs({ "typescript", "javascript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[language] = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = vim.fn.getcwd(),
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = vim.fn.getcwd(),
            },
            {
                type = "pwa-chrome",
                request = "launch",
                name = "Debug Angular (Brave)",
                url = function()
                    return "http://localhost:"
                        .. vim.fn.input({
                            prompt = "Port: ",
                            default = "4200",
                        })
                end,
                webRoot = "${workspaceFolder}",
                runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
            },
            {
                type = "pwa-node",
                request = "launch",
                name = "Debug TypeScript with ts-node (local node_modeules/.bin/ts-node)",
                program = "${file}",
                cwd = "${workspaceFolder}",
                runtimeExecutable = "${workspaceFolder}/node_modules/.bin/ts-node",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                resolveSourceMapLocations = {
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
                skipFiles = { "<node_internals>/**" },
            },
            {
                type = "pwa-chrome",
                request = "launch",
                name = "Debug React (Vite)",
                url = function()
                    return "http://localhost:" .. vim.fn.input({ prompt = "Port: ", default = "5173" })
                end,
                webRoot = "${workspaceFolder}",
                sourceMaps = true,
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                trace = true,
                runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
            },
        }
    end

    -- dap.configurations.typescript = {
    --     {
    --         type = "pwa-node",
    --         request = "launch",
    --         name = "Launch with ts-node",
    --         program = "${file}",
    --         cwd = "${workspaceFolder}",
    --         runtimeExecutable = "node",
    --         runtimeArgs = {
    --             "--loader",
    --             "ts-node/esm", -- For ESM projects
    --             -- "--loader",
    --             -- "tsconfig-paths/register",
    --             "-r", "ts-node/register", -- For CommonJS projects
    --         },
    --         args = { "${file}" },
    --         sourceMaps = true,
    --         protocol = "inspector",
    --         console = "integratedTerminal",
    --     },
    -- }
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
        dap.set_log_level("TRACE")

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

        dotnet_debugging_config(dap)
        rust_debugging_config(dap)
        python_debugging_config(dap)
        js_debugging_config(dap)
        clang_debugging_config(dap)

        vim.keymap.set("n", "<Leader>B", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
        vim.keymap.set("n", "<F10>", function()
            require("dap").step_over()
        end, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", function()
            require("dap").step_into()
        end, { desc = "Step Into" })

        -- breakpoint character for visual queue
        -- vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "red", linehl = "", numhl = "" })
        -- vim.fn.sign_define("DapBreakpointCondition", { text = "🔴", texthl = "red", linehl = "", numhl = "" })
        -- vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "red", linehl = "", numhl = "" })
        -- vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
    end,
}
