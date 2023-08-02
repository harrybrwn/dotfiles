local lazy = require("core.lazy")

-- Plugins
lazy.setup({
  -- Language Server
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                  -- Required
      { 'hrsh7th/cmp-nvim-lsp' },              -- Required
      { 'L3MON4D3/LuaSnip' },                  -- Required
    }
  },

  -- Syntax parsers and highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  },

  -- Commenting utility
  {
    -- "gc" and "gcc" to comment lines and regions
    "numToStr/Comment.nvim",
    tag = "v0.8.0",
    config = function()
      require("Comment").setup {}
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = require("core.plugins.lualine"),
    dependencies = {
      'nvim-tree/nvim-web-devicons' -- Icon set
    },
  },

  -- Auto closes brackets
  "rstacruz/vim-closer",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Auto formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
    opts = function()
      require("core.plugins.null-ls")
    end,
  },

  -- Alternate file explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Function signature pop-up
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },

  -- Themes
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
  { "ntk148v/vim-horizon",   lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "AlexvZyl/nordic.nvim",  lazy = false, priority = 1000 },
})

require("core.settings")
require("core.keymaps")
require("core.plugins")
require("core.lsp")

-- Misc
vim.opt.number        = true
vim.opt.wrap          = true
vim.opt.linebreak     = true
vim.opt.backspace     = "indent,eol,start"
vim.opt.mouse         = 'nv'

-- Tabs
local indent          = 4
vim.opt.tabstop       = indent
vim.opt.shiftwidth    = indent
vim.opt.softtabstop   = indent
vim.opt.expandtab     = true
vim.opt.smartindent   = true

-- Searching
vim.opt.hlsearch      = true -- highlight searches
vim.opt.incsearch     = true

-- Status Line
vim.opt.laststatus    = 2
vim.opt.showmode      = false

-- Colors
vim.opt.syntax        = "on"
vim.opt.background    = "dark"
vim.opt.termguicolors = false
vim.cmd.colorscheme("tokyonight")
-- vim.cmd.colorscheme("grey")

-- History and Persistant Data
vim.opt.history    = 1000
vim.opt.undolevels = 1500
