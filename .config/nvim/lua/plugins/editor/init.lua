local mods = {}

vim.list_extend(mods, require("plugins.editor.syntax"))
vim.list_extend(mods, require("plugins.editor.diagnostics"))

return mods
