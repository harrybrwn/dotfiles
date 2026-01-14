return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
      require("core.lsp").init()
    end,
  },

  -- Auto install and auto enable my LSPs
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    -- init = lspinit,
    opts = {
      automatic_enable = false,
      ensure_installed = {
        -- Languages/Frameworks
        "pyright",          -- python (lsp)
        "ruff",             -- python (linting/formatting)
        "gopls",            -- golang
        "golangci_lint_ls", -- golangci-lint
        "rust_analyzer",    -- rust
        "clangd",           -- c/c++
        "sqlls",            -- sql
        "lua_ls",           -- lua
        "html",             -- html
        "astro",            -- astro.js
        "verible",          -- SystemVerilog
        "ts_ls",            -- typescrypt
        "eslint",           -- web stuff
        "cssls",            -- css
        "tailwindcss",      -- tailwind
        "bashls",
        -- Configuration/Tools
        "ansiblels",                       -- ansible
        "terraformls",                     -- terraform
        "dockerls",                        -- docker
        "docker_compose_language_service", -- docker-compose
        "yamlls",                          -- yaml
        "jsonls",                          -- json
        --"asm_lsp",          -- GAS/NASM/Go assembly
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    -- lazy = false,
    -- event = "InsertEnter",
    -- event = 'VimEnter',
    -- event = "UIEnter",
    event = "VeryLazy",
    config = function()
      require("core.plugins.lsp").setup_cmp()
    end,
    -- build = 'make install_jsregexp',
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Function signature pop-up
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Display temporary LSP messages in the corner.
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    tag = "v1.6.1",
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
  },

  -- Use LSP for inlay hints.
  { "lvimuser/lsp-inlayhints.nvim", enabled = false, opts = {}, lazy = false },
}
