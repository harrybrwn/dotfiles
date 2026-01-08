local path = require("core.util.path")

return {
  -- Use treesitter to autoclose html tags
  { "windwp/nvim-ts-autotag", lazy = false },

  -- Snippets for completion
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.4.1",
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

  -- null-ls auto formatting
  {
    "nvimtools/none-ls.nvim",
    -- TODO Check for a tag (they haven't done a release yet but I want to
    -- freeze the version once they release a version).
    --
    -- https://github.com/nvimtools/none-ls.nvim
    enabled = false,
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

  {
    "harrybrwn/manage-buffers.nvim",
    lazy = false,
    dev = true,
    opts = {},
    enabled = function()
      local p = path.join(
        vim.fn.stdpath("config"),
        "dev/manage-buffers.nvim/lua/manage-buffers/init.lua"
      )
      local f = io.open(p)
      if f ~= nil then
        io.close(f)
        return true
      else
        return false
      end
    end,
  },

  {
    "DrKJeff16/project.nvim",
    dependencies = { -- OPTIONAL
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
    },
    enabled = false,
    lazy = false,
    opts = {},
    keys = {
      {
        '<leader>pf',
        function() vim.cmd [[Telescope projects]] end,
        mode = { 'n' },
        desc = '[P]roject [F]ind',
      },
    },
  },
}
