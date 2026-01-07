local mods = {
  {
    "folke/todo-comments.nvim",
    lazy = false,
    -- enabled = true,
    opts = {
      signs = true,
      sign_priority = 1,                  -- don't place icons on top of git signs
      highlight = {
        pattern = [[.*<(KEYWORDS)>\s*:]], -- default: [[.*<(KEYWORDS)\s*:]]
      },
    },
    keys = {
      { '<leader>sit', "<cmd>TodoTelescope<cr>", mode = { 'n' }, desc = "[S]earch [I]n [T]odo comments" },
    },
  },
}

vim.list_extend(mods, require("plugins.editor.treesitter"))
vim.list_extend(mods, require("plugins.editor.diagnostics"))
vim.list_extend(mods, require("plugins.editor.html-tag-auto-complete"))

return mods
