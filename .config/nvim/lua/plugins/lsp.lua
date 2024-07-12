return {
  -- Language Server
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "williamboman/mason.nvim" }, -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      -- Snippets
      { "L3MON4D3/LuaSnip" }, -- Required
      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
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
          -- disabled
          json = false,
          jsonc = false,
          javascript = false,
          python = false,
          yaml = false,
        },
        ensure_installed = {
          -- Languages/Frameworks
          "pyright", -- python
          "gopls", -- golang
          "golangci_lint_ls",
          "rust_analyzer", -- rust
          "clangd", -- c/c++
          "sqlls", -- sql
          --'rnix', -- nix
          "nil_ls", -- nix
          "lua_ls", -- lua
          "html", -- html
          "astro", -- astro.js
          "verible", -- SystemVerilog
          "asm_lsp", -- GAS/NASM/Go assembly
          "tsserver", -- typescript
          "eslint", -- web stuff
          "cssls", -- css
          "tailwindcss", -- tailwind
          "volar", -- vue
          -- Configuration/Tools
          "ansiblels", -- ansible
          "terraformls", -- terraform
          "dockerls", -- docker
          "bufls", -- protobuf
          "docker_compose_language_service", -- docker-compose
          "yamlls", -- yaml
          "jsonls", -- json
        },
      })
    end,
  },

  -- Use LSP for inlay hints.
  { "lvimuser/lsp-inlayhints.nvim", opts = {}, lazy = false },

  -- Function signature pop-up
  { "ray-x/lsp_signature.nvim", event = "VeryLazy", opts = {} },
}
