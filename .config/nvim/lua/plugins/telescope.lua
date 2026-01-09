return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.1",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Lets me pass rg flags via the search bar.
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = { ["<C-j>"] = "close" },
        n = { ["<C-j>"] = "close" },
      },
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
  keys = function()
    local builtin = require("telescope.builtin")
    local function find_files()
      builtin.find_files({
        no_ignore = true,
      })
    end
    local function live_grep()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end
    return {
      { "<leader>sf",   find_files,        mode = "n", desc = "[S]earch [F]iles" },
      { "<leader>sg",   live_grep,         mode = "n", desc = "[S]earch with [G]rep" },
      { "<leader>sik",  builtin.keymaps,   mode = "n", desc = "[S]earch [I]n [K]eymaps" },
      { "<leader>sib",  builtin.buffers,   mode = "n", desc = "[S]earch [I]n [B]uffers" },
      { "<leader>sigf", builtin.git_files, mode = "n", desc = "[S]earch [I]n [G]it [F]iles" },
      { "<leader>sr",   builtin.resume,    mode = "n", desc = "[S]earch [R]esume. Resume the previous search." },
      {
        "<leader>?",
        function()
          builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        mode = "n",
        desc = "[?] Fuzzy search in the current buffer",
      }
    }
  end,
  -- `spec.init` runs after `spec.config` which means everything in `init` will
  -- run after lazy calls `require('telescope').setup(opts)`.
  --init = function()
  --  require("core.plugins.telescope").init()
  --end,
}
