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

  {
    "windwp/nvim-autopairs",
    --event = "InsertEnter",
    opts = {
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "scheme",
        "lisp",
        "text",
        "markdown",
      },
      enable_check_bracket_line = false,
      check_ts = true,
      ts_config = {
        -- go = { 'string', 'comment' },
        -- lua = { 'string', 'comment' },
        ['*'] = { "string" }, -- don't pair when in these tree-sitter nodes
        basic = false,        -- don't check tree-sitter for basic
      },
    },
    init = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
      local ts_conds = require('nvim-autopairs.ts-conds')
      local npairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')

      -- press % => %% only while inside a comment or string
      npairs.add_rules({
        -- Rule('```', '```', 'markdown'):only_cr(),
        Rule('then', 'end', 'lua')
            :with_pair(ts_conds.is_not_ts_node({ 'string', 'comment' }))
            :end_wise(function(opts)
              -- Add any context checks here, e.g. line starts with "if"
              return string.match(opts.line, '^%s*if') ~= nil
            end),
      })
    end
  },

  -- Use treesitter to autoclose html tags
  { "windwp/nvim-ts-autotag", lazy = false },

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
