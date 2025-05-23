return {
  -- Use treesitter to autoclose html tags
  { "windwp/nvim-ts-autotag", lazy = false },

  -- null-ls auto formatting
  {
    "nvimtools/none-ls.nvim",
    -- TODO Check for a tag (they haven't done a release yet but I want to
    -- freeze the version once they release a version).
    --
    -- https://github.com/nvimtools/none-ls.nvim
    enabled = true,
    event = "BufRead",
    opts = function(_, _)
      -- return require("core.plugins.null-ls")
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting
      local diags = null_ls.builtins.diagnostics
      return {
        default_timeout = 50000,
        sources = {
          fmt.nixfmt,
          fmt.goimports,
          -- fmt.goimports_reviser,
          diags.actionlint,
          diags.buf,
          fmt.prettier.with({
            filetypes = { "html", "svg" },
          })
        },
      }
    end,
    -- must load after lsp-zero.setup
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
  },

  -- Snippets for completion
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.3.0",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Extra tab features
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",     -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    --keys = {
    --  { "<A-,>", "<Cmd>BufferPrevious<CR>", mode = { "n" }, desc = "Prev tab", noremap = true,  silent = true },
    --  { "<A-.>", "<Cmd>BufferNext<CR>",     mode = { "n" }, desc = "Next tab", noremap = true,  silent = true },
    --},
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
  },
}
