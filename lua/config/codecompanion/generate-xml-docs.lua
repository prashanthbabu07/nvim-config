return function(selection)
    return [[
Review the following selection to "Generate C# XML documentation".

CRITERIA:
1. Analyze the code to identify classes, methods, properties, and other relevant code constructs that require documentation.
2. Generate XML documentation comments for each identified construct, including summaries, parameter descriptions, and return value descriptions where applicable.
3. Ensure that the generated documentation is clear, concise, and accurately reflects the functionality of the code.

OUTPUT:
- Provide ONLY the generated XML documentation comments for each relevant code construct.
- Do NOT include any additional explanations, summaries, or suggestions; only provide the XML documentation.

-- Code selection:
-- ```csharp
-- ]] .. selection .. "\n```"
end
