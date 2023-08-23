require("core.settings")
require("core.keymaps")
require("core.autocmds")
local helpers = require("core.helpers")
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
      -- Snippets
      { 'L3MON4D3/LuaSnip',                 tag = 'v2.0.0' }, -- Required
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                                 -- Required
      { 'hrsh7th/cmp-nvim-lsp' },                             -- Required
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
  },

  -- Function signature pop-up
  {
    "ray-x/lsp_signature.nvim",
    -- event = "VeryLazy",
    -- must load after lsp-zero.setup
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    lazy = false,
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  },

  -- Snippets for completion
  {
    "L3MON4D3/LuaSnip",
    tag = 'v2.0.0',
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Syntax parsers and highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.0",
    config = helpers.with_notify_disabled(function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end),
  },

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

  -- Themes
  --
  -- Look for more good ones here https://github.com/rockerBOO/awesome-neovim#tree-sitter-supported-colorscheme
  { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night", -- storm, moon, night, day
    },
  },
  { "ntk148v/vim-horizon",   lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "AlexvZyl/nordic.nvim",  lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim",  lazy = false, priority = 1000 },
  { "sainnhe/everforest",    lazy = false, priority = 1000 },
  -- { "shaunsingh/solarized.nvim" },
  "maxmx03/solarized.nvim",
  -- { "svrana/neosolarized.nvim", lazy = false, priority = 1000 },
  "sainnhe/sonokai",
  { "catppuccin/nvim",         tag = "v1.4.0" },
  "ntk148v/komau.vim",
  -- { "yorickpeterse/nvim-grey", lazy = false, priority = 1000 },
  { import = "plugins" },
  { import = "plugins.lualine" },
})

require("core.plugins")

-- Misc
vim.opt.number        = true
vim.opt.wrap          = false
vim.opt.linebreak     = true
vim.opt.backspace     = "indent,eol,start"
vim.opt.mouse         = 'nv'
vim.opt.fixendofline  = false
vim.opt.spell         = true
vim.opt.spelllang     = "en"
-- vim.opt.spellfile     = './.spell.add' .. ',' .. vim.fn.expand("~/.config/nvim/spell/custom.add")

-- Tabs
local indent          = 4
vim.opt.tabstop       = indent
vim.opt.shiftwidth    = indent
vim.opt.softtabstop   = indent
vim.opt.expandtab     = true
vim.opt.smartindent   = true
vim.opt.colorcolumn   = '80'
vim.opt.formatoptions = {
  t = true,  -- autowrap using textwidth
  c = true,  -- autowrap using textwidth and insert comment
  q = true,  -- format comments with "gq"
  j = true,  -- remove comment when joining lines
  r = true,  -- insert comment on <Enter>
  o = false, -- insert comment on "o" and "O"
}
vim.opt.textwidth     = 80

-- Searching
vim.opt.hlsearch      = true -- highlight searches
vim.opt.incsearch     = true

-- Status Line
vim.opt.laststatus    = 2
vim.opt.showmode      = false

-- Colors
local theme           = vim.cmd.colorscheme
vim.opt.syntax        = "on"
vim.opt.background    = "dark"
vim.opt.termguicolors = true
-- theme("tokyonight")
-- theme("everforest")
-- theme("horizon")
-- theme("kanagawa")
-- theme("gray")
-- theme("bw")
-- theme("habamax")
-- theme("nord")
-- theme("solarized")
theme("catppuccin")
-- theme("sonokai")
-- theme("komau")
vim.cmd("highlight SpellBad guifg=NONE guibg=NONE gui=underline")

-- History and Persistent Data
vim.opt.history    = 1000
vim.opt.undolevels = 1500
