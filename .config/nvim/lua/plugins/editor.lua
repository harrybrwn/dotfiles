local path = require("core.util.path")

return {
  { import = "plugins.editor.treesitter" },
  { import = "plugins.editor.diagnostics" },
  { import = "plugins.editor.html-tag-auto-complete" },

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
    event = "VeryLazy", -- Always load but at the end (for LSP formatting)
    ft = { "go" },      -- always load for go (to use goimports)
    cmd = { 'ConformInfo' },
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
        python = { 'black', 'isort' },
      },
      format_on_save = nil,
      format_after_save = { -- see :help conform.format
        lsp_format = "last",
        async = true,
        quiet = false,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      signs = true,
      sign_priority = 1, -- don't place icons on top of git signs
      highlight = {
        pattern = [[.*<(KEYWORDS)>\s*:]],
      },
    },
    keys = {
      { '<leader>sit', "<cmd>TodoTelescope<cr>", mode = { 'n' }, desc = "[S]earch [I]n [T]odo comments" },
    },
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
    "harrybrwn/floatterm",
    enabled = false,
    dev = true,
    lazy = false,
    opts = {
      item = "test",
      one = 1,
    },
    build = function()
      local dir = vim.fn.stdpath('config') .. '/dev/floatterm'
      require('floatterm.build').build(dir)
    end,
    -- config = function(_, _)
    --   require("floatterm")
    -- end,
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
