-- Language specific plugins.
return {
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
  { "sevko/vim-nand2tetris-syntax", enabled = false, lazy = false },
  { "towolf/vim-helm",              enabled = false, config = false, lazy = false },

  {
    "OXY2DEV/markview.nvim",
    enabled = function()
      local version = vim.version()
      return version.major == 0 and version.minor >= 10
    end,
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
  },

  { -- SQL query runner and connection manager.
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Dbee" },
    opts = {},
    config = function(_, opts)
      vim.env.PGSERVICEFILE = nil
      vim.env.PGSERVICE = nil
      require("dbee").setup(opts)
    end,
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
  },
}
