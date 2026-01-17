return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.1",
  -- event = 'VimEnter',
  event = 'VeryLazy', -- always load but asynchronously
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- Lets me pass rg flags via the search bar.
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- Better option picker
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },

  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension("ui-select")
  end,

  opts = function()
    local actions = require('telescope.actions')
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "close",
            ["<A-p>"] = function(prompt_buffer) require("telescope.actions.layout").toggle_preview(prompt_buffer) end,
          },
          n = {
            -- ['<C-u>'] = function(prompt_buf) require('telescope.actions').results_scrolling_up(prompt_buf) end,
            ['<C-u>'] = actions.results_scrolling_up,
            ['<C-d>'] = actions.results_scrolling_down,
            ['<C-h>'] = actions.results_scrolling_left,
            ['<C-l>'] = actions.results_scrolling_right,
            ['<C-e>'] = actions.preview_scrolling_down,
            ['<C-y>'] = actions.preview_scrolling_up,
            ["<A-p>"] = function(prompt_buffer) require("telescope.actions.layout").toggle_preview(prompt_buffer) end,
          },
        },
        vimgrep_arguments = {
          -- Defaults
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case",
          -- My stuff
          "--hidden",                 -- always include hidden files
        },
        fname_width = 80,             -- view width for the filename
        layout_strategy = 'vertical', -- horizontal|vertical|center|cursor
        -- path_display = "smart",
        path_display = { smart = {} },
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
            -- pass additional flags to rg(1)
            return { "--hidden" }
          end,
          --additional_args = { "--hidden" },
          path_display = {
            shorten = {
              -- lua/core/plugins/codecompanion/lualine.lua
              -- becomes
              -- lu/co/pl/codecompanion/lualine.lua
              len = 2,
              exclude = { -3, -2, -1 },
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
          path_display = {
            truncate = 1,
          },
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            previewer = false,
          })
        },
      },
    }
  end,

  keys = function()
    -- utils
    local function get_ivy() return require('telescope.themes').get_ivy({ no_ignore = true }) end
    -- handlers
    local function find_files() require("telescope.builtin").find_files(get_ivy()) end
    local function live_grep() require("telescope").extensions.live_grep_args.live_grep_args() end
    local function zettelkasten() require('telescope').extensions.zettelkasten.zettelkasten(get_ivy()) end
    local function keymaps() require("telescope.builtin").keymaps() end
    local function buffers() require("telescope.builtin").buffers() end
    local function git_files() require("telescope.builtin").git_files() end
    local function resume() require("telescope.builtin").resume() end
    local function help() require("telescope.builtin").help_tags() end
    local function search()
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end
    local function history()
      --require('telescope.builtin').search_history()
      error("cannot find a way to list telescope search history")
    end
    return {
      { "<leader>sf",   find_files,   mode = "n", desc = "[S]earch [F]iles" },
      { "<leader>sg",   live_grep,    mode = "n", desc = "[S]earch with [G]rep" },
      { "<leader>sik",  keymaps,      mode = "n", desc = "[S]earch [I]n [K]eymaps" },
      { "<leader>sib",  buffers,      mode = "n", desc = "[S]earch [I]n [B]uffers" },
      { "<leader>sigf", git_files,    mode = "n", desc = "[S]earch [I]n [G]it [F]iles" },
      { "<leader>sr",   resume,       mode = "n", desc = "[S]earch [R]esume. Resume the previous search." },
      { "<leader>sh",   help,         mode = "n", desc = "[S]earch in [H]elp tags." },
      { "<leader>sz",   zettelkasten, mode = "n", desc = "[S]earch in [Z]ettelkasten notes." },
      { "<leader>siz",  zettelkasten, mode = "n", desc = "[S]earch [I]n [Z]ettelkasten notes." },
      { "<leader>sih",  history,      mode = "n", desc = "[S]earch [I]n [H]istory" },
      { "<leader>?",    search,       mode = "n", desc = "[?] Fuzzy search in the current buffer" }
    }
  end,
}
