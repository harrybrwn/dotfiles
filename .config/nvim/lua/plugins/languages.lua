local plugins = {}
local version = vim.version()

if version.major == 0 and version.minor >= 10 then
  table.insert(plugins, {
    "OXY2DEV/markview.nvim",
    enabled = false,
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
    -- init = function(plugin)
    -- end,
    -- config = function()
    --   require("markview").setup()
    -- end,
  })
end

table.insert(plugins, {
  { "sevko/vim-nand2tetris-syntax", lazy = false },
})

return plugins
