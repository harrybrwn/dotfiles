local function init()
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
return { init = init }
