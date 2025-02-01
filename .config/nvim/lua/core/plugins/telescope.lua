local telescope = require("telescope")
local builtin = require("telescope.builtin")
local tele_themes = require("telescope.themes")

local function find_files()
  builtin.find_files({
    hidden = true,
  })
end

local function grep_string()
  builtin.grep_string({
    search = vim.fn.input("grep> "),
  })
end

local function live_grep()
  telescope.extensions.live_grep_args.live_grep_args()
end

local M = {}

function M.init()
  local set = vim.keymap.set
  set("n", "<leader>?", function()
    builtin.current_buffer_fuzzy_find(tele_themes.get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[?] Fuzzy search in the current buffer" })
  set("n", "<leader>sf", find_files, { desc = "[S]earch [F]iles" })
  set("n", "<leader>sg", live_grep, { desc = "[S]earch by [G]rep" })
  -- set("n", "<C-p>", tele.git_files)
  --set("n", "<leader>ps", grep_string, { desc = "Grep for a string" })
  -- set("n", "<leader>sk", )
  set("n", "<leader>sik", builtin.keymaps, { desc = "[S]earch [I]n [K]eymaps" })
  set("n", "<leader>sib", builtin.buffers, { desc = "[S]earch [I]n [B]uffers" })
  set("n", "<leader>sigf", builtin.git_files, { desc = "[S]earch [I]n [G]it [F]iles" })
  set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume. Resume the previous search." })
end

return M
