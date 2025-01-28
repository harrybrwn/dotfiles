local path = require("core.util.path")
local nvm = require("core.util.nvm")

return {
  -- Github Copilot
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      local name = vim.fn.hostname()
      return name == "jcadmin-Latitude-9520" and os.getenv("USER") == "hbrown"
    end,
    lazy = false,
    cmd = "Copilot",
    opts = function()
      local nvm_dir = nvm.dir()
      local version = nvm.default(nvm_dir)
      return {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<S-Tab>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        copilot_node_command = path.join(nvm_dir, "versions/node", version, "bin/node"),
        filetypes = {
          help = false,
        },
      }
    end,
  },

  -- Markdown live previews in a web browser
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
