local set = vim.keymap.set
local tele = require("telescope.builtin")
local tele_themes = require("telescope.themes")

local function find_files()
  tele.find_files {
    hidden = true,
  }
end

local function live_grep()
  tele.live_grep()
end

local function grep_string()
  tele.grep_string {
    search = vim.fn.input("grep> "),
  }
end

set("n", "<leader>?", function()
  tele.current_buffer_fuzzy_find(tele_themes.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[?] Fuzzy search in the current buffer" })
set("n", "<leader>sf", find_files, { desc = "[S]earch [F]iles" })
set("n", "<leader>sg", live_grep, { desc = "[S]earch by [G]rep" })
set("n", "<C-p>", tele.git_files)
set("n", "<leader>ps", grep_string, { desc = "Grep for a string" })
