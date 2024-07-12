local plugins = {}
local version = vim.version()

if version.major == 0 and version.minor >= 10 then
  table.insert(plugins, {
    "OXY2DEV/markview.nvim",
    enabled = true,
    -- lazy = false,
    ft = { "md", "markdown" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    -- config = function()
    --   require("markview").setup()
    -- end,
  })
end

return plugins
