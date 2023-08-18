local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
local utils = require("null-ls/utils")

local fmt = null_ls.builtins.formatting

local opts = {
  sources = {
    fmt.gofmt,
    fmt.goimports_reviser,
    fmt.golines,
    fmt.stylua,
    fmt.rustfmt,
    fmt.terraform_fmt,
    fmt.trim_whitespace.with({
      filetypes = { 'text', 'sh', 'toml', 'make', 'conf', 'tmux' },
    }),
    null_ls.builtins.formatting.eslint.with({
      condition = function ()
        return utils.make_conditional_utils().root_has_file(".eslintrc.ejs")
      end
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

-- If lsp-zero is being used, this should be called after lsp-zero's setup function is called.
null_ls.setup(opts)
