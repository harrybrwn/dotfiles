return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.1.0",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = { ["<C-j>"] = "close" },
        n = { ["<C-j>"] = "close" },
      },
      file_ignore_patterns = { ".git" },
      vimgrep_arguments = {
        -- Defaults
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        -- My stuff
        "--hidden",                 -- always include hidden files
      },
      layout_strategy = 'vertical', -- horizontal|vertical|center|cursor
      layout_config = {
        height = 0.95,
        width = 0.95,
        vertical = {
          height = 0.95,
          width = 0.95,
          preview_height = 0.50,
          preview_cutoff = 40,
          prompt_position = "bottom",
        }
      },
      path_display = "smart",
    },
    pickers = {
      live_grep = {
        ---@diagnostic disable-next-line: unused-local
        additional_args = function(opts)
          return { "--hidden" }
        end,
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
      }
    },
  },
  -- `spec.init` runs after `spec.config` which means everything in `init` will
  -- run after lazy calls `require('telescope').setup(opts)`.
  init = function()
    require("core.plugins.telescope").init()
    local telescope = require("telescope")
    telescope.load_extension("live_grep_args")
  end,
}
