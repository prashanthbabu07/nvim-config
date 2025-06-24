local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("///", {
        t({ "/// <summary>", "/// " }),
        i(1, "Summary goes here"),
        t({ "", "/// </summary>" }),
        t({ "", '/// <param name="' }),
        i(2, "param"),
        t({ '">' }),
        i(3, "description"),
        t({ "</param>" }),
        t({ "", "/// <returns>" }),
        i(4, "return description"),
        t("</returns>"),
    }),
}
