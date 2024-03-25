require("core.plugins.custom-editorconfig").setup()
local table = require("table")

-- Folding
-- zf[motion] Create a fold
-- zo         Open a fold
-- zc         Close a fold
-- zd         Delete a fold
-- zE         Eliminate all file folds

vim.opt.foldcolumn = "auto" -- shows folds in gutter (left of line numbers)
vim.opt.foldopen = table.concat({
	"insert",
	"mark",
	"percent",
	"quickfix",
	"search",
	"tag",
	"undo",
}, ",")
