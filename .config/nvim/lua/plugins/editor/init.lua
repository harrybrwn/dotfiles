local mods = {}

vim.list_extend(mods, require("plugins.editor.treesitter"))
vim.list_extend(mods, require("plugins.editor.diagnostics"))
vim.list_extend(mods, require("plugins.editor.html-tag-auto-complete"))

return mods
