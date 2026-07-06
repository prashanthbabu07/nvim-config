return {
    ["Contextual inconsistency"] = {
        interaction = "chat",
        description = "Detects contextual inconsistencies in the provided text.",
        opts = { is_default = false, is_slash_cmd = true },
        prompts = {
            role = "user",
            content = require("config.codecompanion.contextual-inconsistency"),
        },
    },
    ["Logging inconsistency"] = {
        interaction = "chat",
        description = "Detects logging inconsistencies in the provided text.",
        opts = { is_default = false, is_slash_cmd = true },
        prompts = {
            role = "user",
            content = require("config.codecompanion.logging-inconsistency"),
        },
    },

    ["Generate C# XML Doc"] = {
        interaction = "inline",
        description = "Generate C# XML documentation for the given selection",
        opts = { is_default = false, placement = "before" },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return require("config.codecompanion.generate-xml-docs")(selection)
                end,
            },
        },
    },

    ["Project standards review"] = {
        interaction = "chat",
        description = "Reviews the provided code for adherence to project standards.",
        opts = { is_default = false, is_slash_cmd = true },
        prompts = {
            role = "user",
            content = require("config.codecompanion.csharp-code-review"),
        },
    },

    ["Rename Variable"] = {
        interaction = "inline",
        description = "Rename the variable correctly in given selection based on context",
        opts = { is_default = false },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return "Please rename the variable correctly in the given selection based on the code context:\n\n```"
                        .. context.filetype
                        .. "\n"
                        .. selection
                        .. "\n```"
                end,
            },
        },
    },

    ["Fix Typos"] = {
        interaction = "inline",
        description = "Fix typos in the given code selection",
        opts = { is_default = false },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return "Please fix the typos in the given code selection safely without altering core logic:\n\n```"
                        .. context.filetype
                        .. "\n"
                        .. selection
                        .. "\n```"
                end,
            },
        },
    },

    ["Suggest Method Names"] = {
        interaction = "chat",
        description = "Suggest method names for the given selection based on functionality",
        opts = { is_default = false },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return
                        "Please suggest meaningful, clean method names for the following code selection based on its strict functional operations:\n\n```"
                        .. context.filetype
                        .. "\n"
                        .. selection
                        .. "\n```"
                end,
            },
        },
    },
    ["Write Unit Tests MsTests"] = {
        interaction = "chat",
        description = "Write unit tests in MsTests for the given selection",
        opts = { is_default = false },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return
                        "Please write unit tests in MsTests for the following code selection, covering critical paths and edge cases:\n\n```"
                        .. context.filetype
                        .. "\n"
                        .. selection
                        .. "\n```"
                end,
            },
        },
    },
    ["Write integration Tests"] = {
        interaction = "chat",
        description = "Write integration tests for the given selection",
        opts = { is_default = false },
        prompts = {
            {
                role = "user",
                content = function(context)
                    local selection = table.concat(context.lines, "\n")
                    return
                        "Please write integration tests for the following code selection, ensuring proper interaction between components:\n\n```"
                        .. context.filetype
                        .. "\n"
                        .. selection
                        .. "\n```"
                end,
            },
        },
    },
}
