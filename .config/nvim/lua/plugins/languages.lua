-- Language specific plugins.

local version = vim.version()

local plugins = {
  -- UV (python) integration.
  {
    "benomahony/uv.nvim",
    ft = { "python" },
    -- Optional filetype to lazy load when you open a python file
    -- ft = { python }
    -- Optional dependency, but recommended:
    -- dependencies = {
    --   "folke/snacks.nvim"
    -- or
    --   "nvim-telescope/telescope.nvim"
    -- },
    opts = {
      picker_integration = true,
    },
    --lazy = false,
  },
  -- Syntax highlighting for the Nand2Tetris book exercises. (See https://www.nand2tetris.org/)
  { "sevko/vim-nand2tetris-syntax", lazy = false },
  { "towolf/vim-helm",              enabled = false, config = false, lazy = false },
}

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

return plugins
