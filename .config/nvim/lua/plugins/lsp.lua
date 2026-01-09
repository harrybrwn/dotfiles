local function lspinit()
  require("core.plugins.lsp").setup({
    -- explicitly enable or disable auto formatting
    auto_format = {
      go = true,
      rust = true,
      astro = true,
      lua = true,
      tsx = true,
      typescript = true,
      typescriptreact = true,
      terraform = true,
      ruff = true,
      -- disabled
      json = false,
      jsonc = false,
      javascript = false,
      python = false,
      yaml = false,
    },
  })
end

return {
  -- Language Server
  -- TODO: Switch to the 0.11 way of configuring LSPs:
  --  * See https://vonheikemen.github.io/learn-nvim/feature/lsp-setup.html
  --  * See https://gpanders.com/blog/whats-new-in-neovim-0-11/

  -- Auto install and auto enable my LSPs
  {
    "mason-org/mason-lspconfig.nvim",
    priority = 50,
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    init = lspinit,
    opts = {
      automatic_enable = true,
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
    -- event = "UIEnter",
    event = "VeryLazy",
    config = function()
      -- TODO: Move this to a separate file.
      require("core.plugins.lsp").setup_cmp()
    end,
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
