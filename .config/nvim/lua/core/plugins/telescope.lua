local set = vim.keymap.set
local tele = require("telescope.builtin")
local tele_themes = require("telescope.themes")
set("n", "<leader>?", function()
  tele.current_buffer_fuzzy_find(tele_themes.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[?] Fuzzy search in the current buffer" })
set("n", "<leader>sf", tele.find_files, { desc = "[S]earch [F]iles" })
set("n", "<leader>sg", tele.live_grep, { desc = "[S]earch by [G]rep" })
set("n", "<C-p>", tele.git_files)
set("n", "<leader>ps", function() tele.grep_string({ search = vim.fn.input("grep> ") }) end)
