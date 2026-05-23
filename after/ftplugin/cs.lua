vim.opt.foldmethod = 'marker'
vim.opt.foldmarker = '#region,#endregion'

--fold marker by default 
vim.opt.foldenable = true

-- Replace your old marker configs with these local window options
-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"

-- Prevent Neovim from opening files with everything completely collapsed
-- vim.opt_local.foldlevel = 99
-- vim.opt_local.foldlevelstart = 99
-- vim.opt_local.foldenable = true

