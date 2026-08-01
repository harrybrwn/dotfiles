-- Tab Settings
local indent = 2
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt_local.tabstop = indent
vim.opt_local.shiftwidth = indent
vim.opt_local.softtabstop = indent

-- Formatting
vim.opt.formatoptions:remove("t") -- disables autowrap
vim.opt.textwidth = 80            -- TODO: consider 100
