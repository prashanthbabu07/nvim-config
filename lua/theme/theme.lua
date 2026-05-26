local M = {}

local function get_macos_theme()
    if vim.fn.has("mac") == 0 then
        return "unknown"
    end

    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not handle then
        return "unknown"
    end

    local result = handle:read("*a")
    handle:close()

    if result:match("Dark") then
        return "dark"
    else
        -- If AppleInterfaceStyle is not set or anything else, it's typically light
        return "light"
    end
end

local function get_linux_theme()
    if vim.fn.has("unix") == 0 then
        return "unknown"
    end

    local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
    if not handle then
        return "unknown"
    end

    local result = handle:read("*a")
    handle:close()

    if result:match("dark") then
        return "dark"
    else
        return "light"
    end
end

-- Track the current active theme state in memory
M.current_mode = "light"

function M.set_theme(mode)
    M.current_mode = mode
    local ok, theme = pcall(require, "theme." .. mode)
    if ok and theme and type(theme.load) == "function" then
        theme.load()
    else
        vim.o.background = mode
        vim.cmd("colorscheme default")
    end
end

function M.toggle()
    if M.current_mode == "light" then
        M.set_theme("dark")
    else
        M.set_theme("light")
    end
    -- Optional: Print a clean message in the status line
    print("Theme swapped to: " .. M.current_mode)
end

-- Your existing system detection wrapper
function M.init_system_theme()
    -- (Insert your previous get_macos_theme or get_linux_theme logic here)
    local system_mode = get_macos_theme() or get_linux_theme() or "light"
    M.set_theme(system_mode)
end

return M
