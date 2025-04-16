return {
  -- Language Server
  {
    "VonHeikemen/lsp-zero.nvim",
    -- TODO upgrade to "v4.x". Check the repo, there's a migration guide.
    branch = "v3.x",
    lazy = false,
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },             -- Required
      { "williamboman/mason.nvim" },           -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      -- Snippets
      { "L3MON4D3/LuaSnip" },                  -- Required
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },                  -- Required
      { "hrsh7th/cmp-nvim-lsp" },              -- Required
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
    },

    config = function(_, _)
      require("core.plugins.lsp").setup({
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
        ensure_installed = {
          -- Languages/Frameworks
          "pyright",          -- python
          "gopls",            -- golang
          "golangci_lint_ls", -- golangci-lint
          "rust_analyzer",    -- rust
          "clangd",           -- c/c++
          "sqlls",            -- sql
          --"nil_ls",           -- nix
          "lua_ls",           -- lua
          "html",             -- html
          "astro",            -- astro.js
          "verible",          -- SystemVerilog
          --"asm_lsp",                        -- GAS/NASM/Go assembly
          --"tsserver",                        -- typescript
          "ts_ls",                           -- typescrypt
          "eslint",                          -- web stuff
          "cssls",                           -- css
          "tailwindcss",                     -- tailwind
          "volar",                           -- vue
          -- Configuration/Tools
          "ansiblels",                       -- ansible
          "terraformls",                     -- terraform
          "dockerls",                        -- docker
          "docker_compose_language_service", -- docker-compose
          "yamlls",                          -- yaml
          "jsonls",                          -- json
          "helm_ls"
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("core.plugins.lsp").setup_cmp()
    end,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  -- Use LSP for inlay hints.
  { "lvimuser/lsp-inlayhints.nvim", opts = {},           lazy = false },

  -- Function signature pop-up
  { "ray-x/lsp_signature.nvim",     event = "VeryLazy",  opts = {} },

  -- Display temporary LSP info in the corner.
  { "j-hui/fidget.nvim",            event = "LspAttach", opts = {},      tag = "v1.6.1" },

  { "towolf/vim-helm",              enabled = false,     config = false, lazy = false },
}
