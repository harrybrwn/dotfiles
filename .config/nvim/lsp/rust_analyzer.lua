return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      diagnostics = {
        disabled = {
          "unlinked-file",
          "inactive-code",
        },
      },
      -- auto import settings.
      imports = {
        granularity = {
          group = "crate",
        },
        prefix = "plain", -- no prefix restrictions
      },
      procMacro = { enable = true },
      inlayHints = {
        maxLength = 50, -- default 25
        typeHints = {
          enable = true,
          hideNamedConstructor = true,
        },
        parameterHints = { enable = false },
        closingBraceHints = { enable = false }, -- hints after a closing brace
        implicitDrops = { enable = false },
      },
    },
  }
}
