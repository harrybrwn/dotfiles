return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Lets me pass rg flags via the search bar.
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
      fname_width = 80,             -- view width for the filename
      layout_strategy = 'vertical', -- horizontal|vertical|center|cursor
      -- path_display = "smart",
      path_display = {
        smart = {},
      },
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
    },
    pickers = {
      live_grep = {
        ---@diagnostic disable-next-line: unused-local
        additional_args = function(opts)
          return { "--hidden" }
        end,
        path_display = {
          shorten = {
            -- lua/core/plugins/codecompanion/lualine.lua
            -- becomes
            -- lu/co/pl/codecompanion/lualine.lua
            len = 2,
            exclude = { -2, -1 },
          },
        },
      },
      find_files = {
        path_display = {
          absolute = {},
        },
        layout_config = {
          vertical = {
            height = 0.98,
            width = 0.95,
            preview_height = 0.65,
          }
        }
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
  end,
}
