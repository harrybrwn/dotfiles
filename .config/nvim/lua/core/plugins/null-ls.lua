local null_ls = require("null-ls")

local fmt = null_ls.builtins.formatting
local diags = null_ls.builtins.diagnostics

local opts = {
  sources = {
    fmt.stylua,
    fmt.nixfmt,
    fmt.terraform_fmt,
    diags.actionlint,
    diags.buf,
  },
}

-- If lsp-zero is being used, this should be called after lsp-zero's setup function is called.
return opts
