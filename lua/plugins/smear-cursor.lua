if vim.fn.has("mac") == 1 then
    return {}
end
return {
    "sphamba/smear-cursor.nvim",
    opts = {},
    config = function()
        local cursor = require("smear_cursor")
        cursor.setup({
            stiffness = 0.8,
            trailing_stiffness = 0.5,
            distance_stop_animating = 0.5,
        })
    end,
}
