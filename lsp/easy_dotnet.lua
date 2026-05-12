return {
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = false,
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
        ["csharp|metadata"] = {
            enable_decompilation = true,
        },
        ["csharp|navigation"] = {
            -- This ensures it tries to find the best source
            enable_navigation_to_source_generated_files = true,
        },
    },
}
