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

    logging_inconsistency = {
        description = "Review buffer for Logging Inconsistency.",
        prompt = [[
                COPILOT_REVIEW Review #buffer for "Logging Inconsistency".

                CRITERIA:
                1. Identify any log messages that do not accurately reflect the action being performed or the state of the application at that point in the code.
                2. Detect log messages that are misleading, incorrect, or could cause confusion for developers who read them later.
                3. Check for log messages that reference incorrect entities, actions, or states compared to what the code is actually doing.
                4. Check for inconsistent use of logging methods
                5. The Result should use this pattern .LogResult(logger, "Message", args)

                OUTPUT:
                - Provide ONLY a bullet-point list of detected logging inconsistencies, specifying the log message and line number if possible.
                - If no issues are detected, reply with exactly: No logging inconsistencies detected.
                - Do NOT compliment, summarize, explain, or suggest optimizations; only report logging inconsistencies.
        ]],
    },

    generate_csharp_xml_doc = {
        description = "Generate C# XML documentation for the given code.",
        prompt = [[
                COPILOT_REVIEW Review #buffer to "Generate C# XML documentation".

                CRITERIA:
                1. Analyze the code to identify classes, methods, properties, and other relevant code constructs that require documentation.
                2. Generate XML documentation comments for each identified construct, including summaries, parameter descriptions, and return value descriptions where applicable.
                3. Ensure that the generated documentation is clear, concise, and accurately reflects the functionality of the code.

                OUTPUT:
                - Provide ONLY the generated XML documentation comments for each relevant code construct.
                - Do NOT include any additional explanations, summaries, or suggestions; only provide the XML documentation.
        ]],
    },
}

return M
