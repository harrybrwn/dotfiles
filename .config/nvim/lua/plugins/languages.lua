local plugins = {}
local version = vim.version()

if version.major == 0 and version.minor >= 10 then
  table.insert(plugins, {
    "OXY2DEV/markview.nvim",
    enabled = true,
    lazy = false,
    ft = { "md", "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      experimental = {
        -- Ignore warning message about loading treesitter before markview
        check_rtp_message = false,
      }
    },
    keys = {
      {
        "<leader>mt",
        "<cmd>Markview Toggle<cr>",
        desc = "Toggle the markview plugin",
      },
      {
        "<leader>ms",
        "<cmd>Markview splitToggle<cr>",
        desc = "Toggle the markview split view",
      }
    },
  })
end

table.insert(plugins, {
  { "sevko/vim-nand2tetris-syntax", lazy = false },
})

return plugins
