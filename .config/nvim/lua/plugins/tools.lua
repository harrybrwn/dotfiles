return {
  {
    "wsdjeg/calendar.nvim",
    dependencies = {
      'wsdjeg/zettelkasten.nvim', -- contains a nice calendar plugin
    },
    cmd = "Calendar",
    keys = {
      { "<leader>co", vim.cmd.Calendar, desc = "[C]alendar [O]pen" },
    },
  },
  { -- Notes manager
    'wsdjeg/zettelkasten.nvim',
    opts = {
      notes_path = '~/.local/share/zettelkasten',
      templates_path = '~/.local/share/zettelkasten/template',
      -- preview_command = 'pedit',
      -- browseformat = '%f - %h [%r Refs] [%b B-Refs] %t',
    },
    cmd = { "ZkHover", "ZkBrowse", "ZkNew" },
    keys = {
      { "<leader>zb", "<cmd>ZkBrowse<cr>" },
      { "<leader>zn", "<cmd>ZkNew<cr>" },
      { "<leader>co", vim.cmd.Calendar,   desc = "[C]alendar [O]pen" },
    },
    config = function(_, opts)
      vim.schedule(function()
        local util = require('core.util')
        util.mkdir(vim.fn.expand(opts.notes_path), { parents = true })
        util.mkdir(vim.fn.expand(opts.templates_path), { parents = true })
      end)
      require('zettelkasten').setup(opts)
    end,
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
