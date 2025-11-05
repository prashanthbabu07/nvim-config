return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    -- event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }

        dashboard.section.footer.val = {
            "",
            "Yathā antaḥ tathā bāhyam",
            "",
            "Asato mā sad-gamaya, tamaso mā jyotir-gamaya, mrtyor mā amrutam gamaya",
            "",
            "Knowledge is superior to any actiona/practice. Action without understanding is inferior to knowledge.",
        }
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
            dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
            -- dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.vim<CR>"),
            dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
        }
        -- dashboard.section.footer.opts.hl = "Type"
        -- dashboard.section.header.opts.hl = "Include"
        -- dashboard.section.buttons.opts.hl = "Keyword"

        -- dashboard.opts.opts.noautocmd = true
        -- dashboard.section.footer.opts.hl = "GruvboxGreen"
        -- dashboard.section.header.opts.hl = "GruvboxBlue"
        -- dashboard.section.buttons.opts.hl = "GruvboxGreen"
        alpha.setup(dashboard.opts)
    end,
}
