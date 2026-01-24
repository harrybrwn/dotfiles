local basic_notes = false

return {
  {
    "wsdjeg/calendar.nvim",
    enabled = basic_notes,
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
    name = "wsdjeg-zettelkasten",
    enabled = basic_notes,
    opts = function()
      local base
      -- base = vim.fn.expand('~/.local/share/zettelkasten')
      base = vim.fn.expand('~/.cache/zettelkasten')
      return {
        notes_path = base .. '/zettelkasten',
        templates_path = base .. '/zettelkasten/template',
        -- preview_command = 'pedit',
        -- browseformat = '%f - %h [%r Refs] [%b B-Refs] %t',
      }
    end,
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

  {
    "nvim-telekasten/telekasten.nvim",
    enabled = not basic_notes,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      { 'nvim-telekasten/calendar-vim', config = false },
    },
    opts = function()
      local base
      base = vim.fn.expand('~/.local/share/zettelkasten')
      return {
        home = base,
        templates = vim.fs.joinpath(base, 'templates'),
        template_new_daily = vim.fs.joinpath(base, 'templates/daily.md'),
        template_new_weekly = vim.fs.joinpath(base, 'templates/weekly.md'),
        -- calendar_opts = {},
      }
    end,
    cmd = {
      "Telekasten",
      "Calendar", "CalendarH", "CalendarT",
    },
    keys = {
      { "<leader>zo",  "<cmd>Telekasten<CR>",                 mode = "n", desc = "[Z]ettelkasten [O]pen" },
      { "<leader>zf",  "<cmd>Telekasten find_notes<CR>",      mode = "n", desc = "[Z]ettelkasten [F]ind notes" },
      { "<leader>zg",  "<cmd>Telekasten search_notes<CR>",    mode = "n", desc = "[Z]ettelkasten [G]rep notes" },
      { "<leader>zd",  "<cmd>Telekasten goto_today<CR>",      mode = "n", desc = "[Z]ettelkasten goto today" },
      { "<leader>zw",  "<cmd>Telekasten goto_thisweek<CR>",   mode = "n", desc = "[Z]ettelkasten goto [W]eekly note" },
      { "<leader>zz",  "<cmd>Telekasten follow_link<CR>",     mode = "n", desc = "[Z]ettelkasten follow link" },
      { "<leader>zn",  "<cmd>Telekasten new_note<CR>",        mode = "n", desc = "[Z]ettelkasten [N]ew note" },
      { "<leader>zc",  "<cmd>Telekasten show_calendar<CR>",   mode = "n", desc = "[Z]ettelkasten [C]alendar" },
      { "<leader>zb",  "<cmd>Telekasten show_backlinks<CR>",  mode = "n", desc = "[Z]ettelkasten [B]acklinks" },
      { "<leader>zt",  "<cmd>Telekasten show_tags<cr>",       mode = "n", desc = "[Z]ettelkasten show [T]ags" },
      { "<leader>zII", "<cmd>Telekasten insert_img_link<CR>", mode = "n", desc = "[Z]ettelkasten [I]nsert [I]mage link" },
      { "<leader>zi",  "<cmd>Telekasten insert_link<CR>",     mode = "n", desc = "[Z]ettelkasten [I]nsert link" },
    },
    config = function(_, opts)
      vim.schedule(function()
        local util = require('core.util')
        util.mkdir(vim.fn.expand(opts.home), { parents = true })
        util.mkdir(vim.fn.expand(opts.templates), { parents = true })
      end)
      require('telekasten').setup(opts)
    end,
  },

  {
    "Furkanzmc/zettelkasten.nvim",
    name = "Furkanzmc-zettelkasten.nvim",
    enabled = false,
    cmd = { "ZkBrowse", "ZkNew" },
    opts = {
      notes_path = vim.fn.expand("~/.cache/zettelkasten"),
    },
    keys = {
      { "<leader>zb", "<cmd>ZkBrowse<cr>" },
      { "<leader>zn", "<cmd>ZkNew<cr>" },
    },
    config = function(_, opts)
      vim.schedule(function()
        local util = require('core.util')
        util.mkdir(vim.fn.expand(opts.notes_path), { parents = true })
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
    opts = {
      -- TODO: <C-b> is mapped to something different and its really annoying,
      -- figure out how to change it.
    },
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

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
  },
}
