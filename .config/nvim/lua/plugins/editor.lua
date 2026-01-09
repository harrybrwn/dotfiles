local path = require("core.util.path")

return {
  -- Use treesitter to autoclose html tags
  { "windwp/nvim-ts-autotag",                        lazy = false },

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

  {
    "stevearc/conform.nvim",
    event = "InsertEnter",
    --event = "VeryLazy",
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
      },
      format_on_save = {
        lsp_format = true,
        async = false,
        timeout_ms = 1000,
      },
    },
  },

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
  { import = "plugins.editor.treesitter" },
  { import = "plugins.editor.diagnostics" },
  { import = "plugins.editor.html-tag-auto-complete" },

  -- null-ls auto formatting
  {
    "nvimtools/none-ls.nvim",
    -- TODO Check for a tag (they haven't done a release yet but I want to
    -- freeze the version once they release a version).
    --
    -- https://github.com/nvimtools/none-ls.nvim
    enabled = false,
    lazy = false,
    opts = function(_, _)
      -- return require("core.plugins.null-ls")
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting
      local diags = null_ls.builtins.diagnostics
      local augroup = vim.api.nvim_create_augroup("MyLspFormatting", {})
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
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      }
    end,
    -- must load after lsp-zero.setup
    -- dependencies = { "VonHeikemen/lsp-zero.nvim" },
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
