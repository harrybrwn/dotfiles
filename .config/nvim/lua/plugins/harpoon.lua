return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
  keys = function()
    local harpoon = require("harpoon")
    local function next()
      harpoon:list():next()
    end
    local function prev()
      harpoon:list():prev()
    end
    local function add()
      harpoon:list():add()
    end
    local keys = {
      { "<C-p>", prev },
      { "<C-n>", next },
      {
        "<leader>H",
        add,
        desc = "Harpoon File",
      },
      {
        "<leader>a",
        add,
        desc = "[A]dd file to Harpoon list",
      },
      {
        "<leader>h",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }
    for i = 1, 5 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
