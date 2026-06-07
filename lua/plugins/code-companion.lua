return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		-- Normal Mode Keymaps
		vim.keymap.set("n", "<leader>cpc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Chat Panel" })
		vim.keymap.set("n", "<leader>cpa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions Menu" })

		-- Visual Selection Mode Keymaps (Evaluates highlights directly)
		vim.keymap.set("v", "<leader>cpa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions Menu" })
		vim.keymap.set("v", "<leader>cpe", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add Selection to Chat Panel" })

		require("codecompanion").setup({
			completion = {
				provider = "copilot",
			},

			adapters = {
				-- Cloud Adapter: Explicitly configured for GPT-5.3-Codex
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-5.3-codex",
							},
						},
					})
				end,

				-- Local Adapter: Quick, snappy 3B model for offline fallback or private files
				qwen_local = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen2.5-coder:3b",
							},
						},
					})
				end,
			},

			strategies = {
				chat = { adapter = "copilot" },
				inline = { adapter = "copilot" },
				cmd = { adapter = "copilot" },
			},

			-- Custom Prompt Library integrating all of your custom actions safely
			prompt_library = {
				["Contextual Inconsistency"] = {
					strategy = "chat",
					description = "Review buffer for Contextual Inconsistency",
					opts = { is_default = false, is_slash_cmd = true },
					prompts = {
						{
							role = "user",
							content = [[Review the provided buffer context for "Contextual Inconsistency".

CRITERIA:
1. Identify any variable names, method names, or parameters that do not match the primary entity referenced by the current class or file name.
2. Detect "Copy-Paste Leftovers": any identifiers or code fragments that appear to belong to a different domain, class, or entity than the one intended in this file.
3. Check string literals (log messages, error messages, exceptions) to ensure they accurately reference the correct entity as described by the file/class name.

OUTPUT:
- Provide ONLY a bullet-point list of detected consistency issues, specifying the variable, identifier, or string literal, and the line number if possible.
- If no issues are detected, reply with exactly: No consistency issues detected.
- Do NOT compliment, summarize, explain, or suggest optimizations; only report inconsistency issues.

Here is the code:

```csharp
#buffer
```]],
						},
					},
				},

				["Logging Inconsistency"] = {
					strategy = "chat",
					description = "Review buffer for Logging Inconsistency",
					opts = { is_default = false, is_slash_cmd = true },
					prompts = {
						{
							role = "user",
							content = [[Review the provided buffer context for "Logging Inconsistency".

CRITERIA:
1. Identify any log messages that do not accurately reflect the action being performed or the state of the application at that point in the code.
2. Detect log messages that are misleading, incorrect, or could cause confusion for developers who read them later.
3. Check for log messages that reference incorrect entities, actions, or states compared to what the code is actually doing.
4. Check for inconsistent use of logging methods.
5. The Result should use this pattern .LogResult(logger, "Message", args)

OUTPUT:
- Provide ONLY a bullet-point list of detected logging inconsistencies, specifying the log message and line number if possible.
- If no issues are detected, reply with exactly: No logging inconsistencies detected.
- Do NOT compliment, summarize, explain, or suggest optimizations; only report logging inconsistencies.

Here is the code:

```csharp
#buffer
```]],
						},
					},
				},

				["Generate C# XML Doc"] = {
					strategy = "inline",
					description = "Generate C# XML documentation for the given selection",
					opts = { is_default = false },
					prompts = {
						{
							role = "user",
							content = function(context)
								local selection = table.concat(context.lines, "\n")
								return [[Review the following selection to "Generate C# XML documentation".

CRITERIA:
1. Analyze the code to identify classes, methods, properties, and other relevant code constructs that require documentation.
2. Generate XML documentation comments for each identified construct, including summaries, parameter descriptions, and return value descriptions where applicable.
3. Ensure that the generated documentation is clear, concise, and accurately reflects the functionality of the code.

OUTPUT:
- Provide ONLY the generated XML documentation comments for each relevant code construct.
- Do NOT include any additional explanations, summaries, or suggestions; only provide the XML documentation.

Code selection:
```csharp
]] .. selection .. "\n```"
							end,
						},
					},
				},

				["Project Standards Review"] = {
					strategy = "chat",
					description = "Review buffer against internal C# .NET architecture standards",
					opts = { is_default = false, is_slash_cmd = true },
					prompts = {
						{
							role = "user",
							content = [[Review the following code buffer against these C# project standards guidelines:

---
applyTo: '**/*.cs'
---
# C# Development
## C# Instructions
- Always use the latest version C#, currently C# 14 features.
- Write clear and concise comments for each function.
## General Instructions
- Make only high confidence suggestions when reviewing code changes.
- Write code with good maintainability practices, including comments on why certain design decisions were made.
- Handle edge cases and write clear exception handling.
- For libraries or external dependencies, mention their usage and purpose in comments.
## Naming Conventions
- Follow PascalCase for component names, method names, and public members.
- Use camelCase for local variables.
- Use _camelCase for private fields, and prefix them with an underscore (e.g., _userService).
- Prefix interface names with "I" (e.g., IUserService).
## Formatting
- Apply code-formatting style defined in `.editorconfig`.
- Prefer file-scoped namespace declarations and single-line using directives.
- Insert a newline before the opening curly brace of any code block (e.g., after `if`, `for`, `while`, `foreach`, `using`, `try`, etc.).
- Ensure that the final return statement of a method is on its own line.
- Use pattern matching and switch expressions wherever possible.
- Use `nameof` instead of string literals when referring to member names.
- Ensure that XML doc comments are created for any public APIs. When applicable, include `<example>` and `<code>` documentation in the comments.
## Project Setup and Structure
- Error Handling - use proper error handling patterns, such as try-catch blocks, and ensure that exceptions are logged appropriately. Avoid empty catch blocks and swallowing exceptions without logging.
- Dependency Injection - utilize dependency injection to manage dependencies and promote testability.
- Organize code using feature folders or domain-driven design principles to improve maintainability and readability.
- Demonstrate how to organize code using feature folders or domain-driven design principles.
- Show proper separation of concerns with models, services, and data access layers.
- Explain the Program.cs and configuration system in ASP.NET Core 10 including environment-specific settings.
## Nullable Reference Types
- Declare variables non-nullable, and check for `null` at entry points.
- Always use `is null` or `is not null` instead of `== null` or `!= null`.
- Trust the C# null annotations and don't add null checks when the type system says a value cannot be null.
## Data Access Patterns
- Guide the implementation of a data access layer using Entity Framework Core.
- Explain different options (SQL Server, SQLite, In-Memory) for development and production.
- Demonstrate repository pattern implementation and when it's beneficial.
- Show how to implement database migrations and data seeding.
- Explain efficient query patterns to avoid common performance issues.
## Validation and Error Handling
- Guide the implementation of model validation using data annotations and FluentValidation.
- Explain the validation pipeline and how to customize validation responses.
- Demonstrate a global exception handling strategy using middleware.
- Show how to create consistent error responses across the API.
- Explain problem details (RFC 9457) implementation for standardized error responses.
## API Versioning and Documentation
- Guide users through implementing and explaining API versioning strategies.
- Demonstrate Swagger/OpenAPI implementation with proper documentation.
- Show how to document endpoints, parameters, responses, and authentication.
- Explain versioning in both controller-based and Minimal APIs.
- Guide users on creating meaningful API documentation that helps consumers.
## Logging and Monitoring
- Guide the implementation of structured logging using Serilog or other providers.
- Explain the logging levels and when to use each.
- Demonstrate integration with Application Insights for telemetry collection.
- Show how to implement custom telemetry and correlation IDs for request tracking.
- Explain how to monitor API performance, errors, and usage patterns.
## Testing
- Always include test cases for critical paths of the application.
- Guide users through creating unit tests.
- Do not emit "Act", "Arrange" or "Assert" comments.
- Copy existing style in nearby files for test method names and capitalization.
- Explain integration testing approaches for API endpoints.
- Demonstrate how to mock dependencies for effective testing.
- Show how to test authentication and authorization logic.
- Explain test-driven development principles as applied to API development.
## Performance Optimization
- Guide users on implementing caching strategies (in-memory, distributed, response caching).
- Explain asynchronous programming patterns and why they matter for API performance.
- Demonstrate pagination, filtering, and sorting for large data sets.
- Show how to implement compression and other performance optimizations.
- Explain how to measure and benchmark API performance.
## Additional Best Practices
- No magic strings or numbers - use constants or enums where appropriate.
- use Results extension methods for creating success and error types.
- Should not catch exceptions for I/O, network or database in repository and services layer they should bubble up to higher layers.
- All *Options class should implement IValidatableOptions and validate their properties.
- Should use file scoped namespaces and single-line using directives.
- Service models sould use EntityId for reference to other entities.

OUTPUT:
- Provide ONLY a bullet-point list of detected consistency issues, specifying the variable, identifier, or string literal, and the line number if possible.
- If no issues are detected, reply with exactly: No consistency issues detected.
- Do NOT compliment, summarize, explain, or suggest optimizations; only report inconsistency issues.

Here is the file content to evaluate:

```csharp
#buffer
```]],
						},
					},
				},

				["Rename Variable"] = {
					strategy = "inline",
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
					strategy = "inline",
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
					strategy = "chat",
					description = "Suggest method names for the given selection based on functionality",
					opts = { is_default = false },
					prompts = {
						{
							role = "user",
							content = function(context)
								local selection = table.concat(context.lines, "\n")
								return "Please suggest meaningful, clean method names for the following code selection based on its strict functional operations:\n\n```"
									.. context.filetype
									.. "\n"
									.. selection
									.. "\n```"
							end,
						},
					},
				},
			},
		})
	end,
}
