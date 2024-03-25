local lazy = require("core.lazy")
require("core.settings")
require("core.keymaps")
require("core.autocmds")

-- Plugins
lazy.setup({ { import = "plugins" } })

require("core.plugins")

-- Misc
vim.opt.number = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.backspace = "indent,eol,start"
vim.opt.mouse = "nv"
vim.opt.fixendofline = false
vim.opt.spell = true
vim.opt.spelllang = "en"
vim.opt.splitright = true

-- Tabs
local indent = 4
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.formatoptions = {
	t = true, -- autowrap using textwidth
	c = true, -- autowrap using textwidth and insert comment
	q = true, -- format comments with "gq"
	j = true, -- remove comment when joining lines
	r = true, -- insert comment on <Enter>
	o = false, -- insert comment on "o" and "O"
}
vim.opt.formatoptions:remove("o")
vim.opt.textwidth = 80

-- Searching
vim.opt.hlsearch = true -- highlight searches
vim.opt.incsearch = true

-- Status Line
vim.opt.laststatus = 2
vim.opt.showmode = false

-- Colors
local theme = vim.cmd.colorscheme
vim.opt.syntax = "on"
vim.opt.background = "dark"
vim.opt.termguicolors = true
theme("terafox") -- tokyonight gruvbox kanagawa everforest onedark gray horizon bw nord nordic solarized kanagawa-wave
vim.cmd("highlight SpellBad guifg=NONE guibg=NONE gui=underline")
-- vim.cmd("highlight FoldColumn guifg=NONE guibg=NONE gui=NONE")

-- color column
vim.opt.colorcolumn = "" -- "80"
-- vim.cmd("highlight ColorColumn guifg=NONE guibg=NONE")

-- History and Persistent Data
vim.opt.history = 1000
vim.opt.undolevels = 1500

-- Make sure this is the first item in the rtp.
vim.opt.runtimepath:prepend(vim.fn.stdpath("config"))
