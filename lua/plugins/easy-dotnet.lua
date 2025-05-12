return {
	"GustavEikaas/easy-dotnet.nvim",
	commit = "50e3d11c16ef80df475e0c92248cdc066bc9fc0a",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		local dotnet = require("easy-dotnet")
		dotnet.setup({
			test_runner = {
				viewmode = "float",
				enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
				noBuild = true,
				noRestore = true,
			},
		})
	end,
}
