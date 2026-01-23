local M = {}

M.prompts = {
    contextual_inconsistency = {
        description = "Review buffer for Contextual Inconsistency.",
        prompt = [[
                COPILOT_REVIEW Review #buffer for "Contextual Inconsistency".

                CRITERIA:
                1. Identify any variable names, method names, or parameters that do not match the primary entity referenced by the current class or file name.
                2. Detect "Copy-Paste Leftovers": any identifiers or code fragments that appear to belong to a different domain, class, or entity than the one intended in this file.
                3. Check string literals (log messages, error messages, exceptions) to ensure they accurately reference the correct entity as described by the file/class name.

                OUTPUT:
                - Provide ONLY a bullet-point list of detected consistency issues, specifying the variable, identifier, or string literal, and the line number if possible.
                - If no issues are detected, reply with exactly: No consistency issues detected.
                - Do NOT compliment, summarize, explain, or suggest optimizations; only report inconsistency issues.
        ]],
    },
}

return M
