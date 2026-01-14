local function enable()
  vim.lsp.enable({
    -- real languages
    "gopls",
    "rust_analyzer",
    "clangd",
    "pyright",
    "sqlls",
    "lua_ls",
    -- web
    "ts_ls",
    "eslint",
    "astro",
    "html",
    -- tools
    "golangci_lint_ls",
    "terraformls",
    -- config and data
    "jsonls",
    "yamlls",
    "ansiblels",
    "bashls",
    "dockerls",
    "docker_compose_language_service",
    "gh_actions_ls",
    "templ",
  })
end

---@param bufnr number
local function keys(bufnr)
  ---@param key string
  ---@param fn string|function
  ---@param desc string
  local function kset(key, fn, desc)
    vim.keymap.set("n", key, fn, { buffer = bufnr, desc = desc })
  end
  kset("K", function() vim.lsp.buf.hover({ border = "single" }) end, "LSP Hover Info")
  kset('gs', function() vim.lsp.buf.signature_help({ border = "single" }) end, 'Show function signature')
  kset("gr", function() vim.cmd [[Telescope lsp_references]] end, "[G]o to LSP [R]eferences")
  kset('gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition')
  kset('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Go to declaration')
  kset('gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Go to implementation')
  kset('go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Go to type definition')
  kset('<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol')
  kset('<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format file')
  kset('<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
  kset("<Tab>", function() vim.lsp.buf.format({ async = true }) end, 'LSP Format')
  vim.keymap.set('x', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
    { desc = 'Format selection', buffer = bufnr })
end

---@param event vim.api.keyset.create_autocmd.callback_args
local function on_attach(event)
  keys(event.buf)
end

return { enable = enable, keys = keys, on_attach = on_attach }
