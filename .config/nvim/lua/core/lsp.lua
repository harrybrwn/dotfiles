local lsp = require('lsp-zero').preset({})

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
})

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")
local lsp_signature = require("lsp_signature")

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.rnix.setup { on_attach = lsp_signature.on_attach }
lspconfig.astro.setup {}
lspconfig.rust_analyzer.setup {
  on_attach = lsp_signature.on_attach,
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
  on_attach = function(client, bufnr)
    lsp_signature.on_attach(client, bufnr)
  end,
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
