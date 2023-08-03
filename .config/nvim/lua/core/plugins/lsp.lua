local lsp = require('lsp-zero').preset({})
local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({ buffer = bufnr })
end)

lsp.ensure_installed({
  'ansiblels',                       -- ansible
  'gopls',                           -- golang
  'lua_ls',                          -- lua
  'astro',                           -- astro.js
  'pylsp',                           -- python
  'rnix',                            -- nix
  'rust_analyzer',                   -- rust
  'html',                            -- html
  'terraformls',                     -- terraform
  'bufls',                           -- protobuf
  'dockerls',                        -- docker
  'docker_compose_language_service', -- docker-compose
  'clangd',                          -- c/c++
})

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.rnix.setup {}
lspconfig.astro.setup {}

lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      }
    }
  }
}

lspconfig.gopls.setup {
  cmd = { "gopls" },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = lsputil.root_pattern("go.work", "go.mod", ".git"),
  settits = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  }
}

local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    -- `Tab` key to confirm completion
    ['<Tab>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

lsp.setup()
require("lsp_signature").setup({})
