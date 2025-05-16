--[[
Running model locally for code companion support
brew install ollama
ollama serve or  brew services start ollama
ollama run codellama:7b

--]]

return {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        require("codecompanion").setup({
            adapter = "ollama", -- or "openai" if using their API
            adapters = {
                ollama = {
                    endpoint = "http://localhost:11434",
                    model = "codellama:7b", -- Or any other pulled model
                },
            },
        })
    end,
}
