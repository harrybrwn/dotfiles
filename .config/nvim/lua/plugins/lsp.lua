return {
  -- Language Server
  -- TODO: Switch to the 0.11 way of configuring LSPs:
  --  * See https://vonheikemen.github.io/learn-nvim/feature/lsp-setup.html
  --  * See https://gpanders.com/blog/whats-new-in-neovim-0-11/
  --  * Remove lsp-zero
  {
    "VonHeikemen/lsp-zero.nvim",
    enabled = true,
    -- TODO upgrade to "v4.x". Check the repo, there's a migration guide.
    branch = "v4.x",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function(_, _)
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
          -- disabled
          json = false,
          jsonc = false,
          javascript = false,
          python = false,
          yaml = false,
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    lazy = false,
    opts = {
      automatic_installation = true,
      ensure_installed = {
        -- Languages/Frameworks
        "pyright",          -- python
        "gopls",            -- golang
        "golangci_lint_ls", -- golangci-lint
        "rust_analyzer",    -- rust
        "clangd",           -- c/c++
        "sqlls",            -- sql
        "lua_ls",           -- lua
        "html",             -- html
        "astro",            -- astro.js
        "verible",          -- SystemVerilog
        --"asm_lsp",                        -- GAS/NASM/Go assembly
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
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
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

  -- Use LSP for inlay hints.
  { "lvimuser/lsp-inlayhints.nvim", enabled = false,    opts = {}, lazy = false },

  -- Function signature pop-up
  { "ray-x/lsp_signature.nvim",     event = "VeryLazy", opts = {} },

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

  { "towolf/vim-helm", enabled = false, config = false, lazy = false },
}
