return {
  cmd = { "gopls" },
  filetype = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.sum" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
}
