return {
  {
    "wsdjeg/calendar.nvim",
    cmd = "Calendar",
    keys = {
      { "<leader>co", vim.cmd.Calendar, desc = "[C]alendar [O]pen" },
    },
  },
  {
    'wsdjeg/zettelkasten.nvim',
    opts = {
      notes_path = '~/.local/share/zettelkasten',
      templates_path = '~/.local/share/zettelkasten/template',
      -- preview_command = 'pedit',
      -- browseformat = '%f - %h [%r Refs] [%b B-Refs] %t',
    },
    cmd = { "ZkHover", "ZkBrowse", "ZkNew", "Calendar" },
    keys = {
      { "<leader>zb", "<cmd>ZkBrowse<cr>" },
      { "<leader>zn", "<cmd>ZkNew<cr>" },
      { "<leader>co", vim.cmd.Calendar,   desc = "[C]alendar [O]pen" },
    },
  },
}
