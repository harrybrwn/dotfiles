--require("core.plugins.custom-editorconfig").setup()

-- Folding
-- zf[motion] Create a fold
-- zo         Open a fold
-- zc         Close a fold
-- zd         Delete a fold
-- zE         Eliminate all file folds

vim.opt.foldcolumn = "auto" -- shows folds in gutter (left of line numbers)
vim.opt.foldopen = table.concat({
  "insert",
  "mark",
  "percent",
  "quickfix",
  "search",
  "tag",
  "undo",
}, ",")

vim.schedule(function()
  vim.filetype.add({
    pattern = {
      [".*/roles/.*/tasks/.*ya?ml"] = "yaml.ansible",
      [".*/local.ya?ml"] = "yaml.ansible",
      [".*/playbooks/.*.ya?ml"] = "yaml.ansible",
      [".*/config/ansible/.*.ya?ml"] = "yaml.ansible",
    }
  })
end)

-- Exclude "curdir" so we don't preserve cwd
vim.opt.viewoptions = "folds,cursor"
