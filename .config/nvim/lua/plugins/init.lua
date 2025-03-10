local path = require("core.util.path")
local nvm = require("core.util.nvm")

return {
  -- Markdown live previews in a web browser
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    ft = {
      "markdown",
      -- "codecompanion",
    },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
