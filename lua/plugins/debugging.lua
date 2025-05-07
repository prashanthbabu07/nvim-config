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

		local debugger_command

		-- Check the operating system
		if vim.fn.has("mac") == 1 then
			debugger_command = "/usr/local/share/dotnet/netcoredbg"
		elseif vim.fn.has("unix") == 1 then
			debugger_command = "/opt/tools/bin/netcoredbg"
		else
			print("Unsupported OS")
		end

		dap.adapters.coreclr = {
			type = "executable",
			-- command = "/usr/local/share/dotnet/netcoredbg/netcoredbg",
			command = debugger_command,
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "", "file")
				end,
			},
		}

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

		vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<F5>", dap.continue, {})
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end)

		-- breakpoint character for visual queue
		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "🛑", texthl = "red", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "red", linehl = "", numhl = "" })
		-- vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })
	end,
}
