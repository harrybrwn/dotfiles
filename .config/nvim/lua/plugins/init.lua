return {
  -- Commenting utility
  {
    -- "gc" and "gcc" to comment lines and regions
    "numToStr/Comment.nvim",
    tag = "v0.8.0",
    lazy = false,
    opts = {
      -- toggler = {
      --   line = "<leader>/",
      --   block = "<leader>/",
      -- }
    },
  },
  -- Auto closes brackets
  -- { "rstacruz/vim-closer", lazy = false },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
    },
  },


  -- Git diffs
  {
    "sindrets/diffview.nvim",
    lazy = false,
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          file_history_panel = {
            { "n", "K", actions.open_commit_log, { desc = "Show commit details" } },
          },
        }
      }
    end,
    -- keys = {
    --   { "<leader>d", "<cmd>DiffviewOpen<cr>", mode = "n" },
    -- }
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      signs                        = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      attach_to_untracked          = true,
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm                         = {
        enable = false
      },
    }
  },

  -- Display lsp diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { height = 5 },
    event = "BufRead",
  },
}
