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
      { 'neovim/nvim-lspconfig' },                            -- Required
      { 'williamboman/mason.nvim' },                          -- Optional
      { 'williamboman/mason-lspconfig.nvim' },                -- Optional
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                                 -- Required
      { 'hrsh7th/cmp-nvim-lsp' },                             -- Required
      { 'L3MON4D3/LuaSnip',                 tag = 'v2.0.0' }, -- Required
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
    opts = {
      -- toggler = {
      --   line = "<leader>/",
      --   block = "<leader>/",
      -- }
    },
  },

  -- Auto closes brackets
  { "rstacruz/vim-closer",     lazy = false },

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
  -- { "rebelot/kanagawa.nvim",   lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim",   lazy = false, priority = 1000 },
  { "AlexvZyl/nordic.nvim",    lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim",    lazy = false, priority = 1000 },
  { "sainnhe/everforest",      lazy = false, priority = 1000 },
  -- { "yorickpeterse/nvim-grey", lazy = false, priority = 1000 },
  { import = "plugins.lualine" },
})

require("core.autocmds")
require("core.plugins")
require("core.helpers")

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
vim.opt.colorcolumn   = '80'
vim.opt.formatoptions = {
  t = true,
  c = true,
  q = true,
  j = true,
} -- default: "tcqj"
vim.opt.textwidth     = 80

-- Searching
vim.opt.hlsearch      = true -- highlight searches
vim.opt.incsearch     = true

-- Status Line
vim.opt.laststatus    = 2
vim.opt.showmode      = false

-- Colors
vim.opt.syntax        = "on"
vim.opt.background    = "dark"
vim.opt.termguicolors = true
-- vim.cmd.colorscheme("tokyonight")
-- vim.cmd.colorscheme("everforest")
-- vim.cmd.colorscheme("horizon")
-- vim.cmd.colorscheme("kanagawa")
-- vim.cmd.colorscheme("gray")
-- vim.cmd.colorscheme("bw")
vim.cmd.colorscheme("nord")

-- History and Persistant Data
vim.opt.history    = 1000
vim.opt.undolevels = 1500

-- dump(list_buffers())
-- for key, value in pairs(list_buffers()) do
--   print('buffer:', key, value)
-- end
