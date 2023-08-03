require("core.settings")
require("core.keymaps")
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
    tag = "v0.9.0",
    config = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  },

  -- Commenting utility
  {
    -- "gc" and "gcc" to comment lines and regions
    "numToStr/Comment.nvim",
    tag = "v0.8.0",
    lazy = false,
    opts = {},
  },

  -- Auto closes brackets
  { "rstacruz/vim-closer" },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        mappings = {
          i = { ["<C-j>"] = "close" },
          n = { ["<C-j>"] = "close" }
        }
      }
    }
  },

  -- Auto formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
    config = function()
      require("core.plugins.null-ls")
    end,
    -- must load after lsp-zero.setup
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
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
  },

  -- Display lsp diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { height = 5 },
    lazy = false,
  },

  -- Themes
  { "navarasu/onedark.nvim",   lazy = false, priority = 1000 },
  { "ntk148v/vim-horizon",     lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim",   lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim",   lazy = false, priority = 1000 },
  { "AlexvZyl/nordic.nvim",    lazy = false, priority = 1000 },
  { import = "plugins.lualine" },
})

require("core.plugins")

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

-- History and Persistant Data
vim.opt.history    = 1000
vim.opt.undolevels = 1500
