---@type LazyPluginSpec[]
return {
  -- Git Diff icons in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = function()
      local opts = {
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          -- 	add = { text = "│" },
          -- change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
          delay = 650,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d %I:%M%p> - <summary>",
        -- current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        worktrees = {},
      }

      local join = vim.fs.joinpath
      local home = vim.env.HOME
      local xdg_config = os.getenv("XDG_CONFIG_HOME") or join(home, ".config")
      local profile = join(vim.env.HOME, ".local/profile.d")
      local cwd = vim.loop.cwd()
      if cwd ~= nil
          and (
            cwd:sub(1, #xdg_config) == xdg_config
            or cwd:sub(1, #profile) == profile
          ) then
        table.insert(opts.worktrees, {
          toplevel = vim.env.HOME,
          gitdir = vim.fs.joinpath(xdg_config, "dots/repo"),
        })
      end
      return opts
    end,
    keys = {
      { "<leader>gB",  "<cmd>Gitsigns blame<cr>",                       mode = { "n" }, desc = "[G]it [B]lame" },
      { "<leader>gb",  "<cmd>Gitsigns toggle_current_line_blame<cr>lh", mode = { "n" }, desc = "[G]it [B]lame" },
      { "<leader>gdw", "<cmd>Gitsigns toggle_word_diff<cr>",            mode = { "n" }, desc = "[G]it [D]iff [W]ord" },
      { "<leader>gs",  "<cmd>Gitsigns stage_hunk<cr>",                  mode = { "v" }, desc = "[G]it [S]tage visual selection" },
      { "<leader>ga",  "<cmd>Gitsigns stage_hunk<cr>",                  mode = { "v" }, desc = "[G]it [A]dd visual selection" },
      { "<leader>gu",  "<cmd>Gitsigns undo_stage_hunk<cr>",             mode = { "v" }, desc = "[G]it [U]nstage visual selection" },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      --"ibhagwan/fzf-lua", -- optional
    },
    cmd = "Neogit",
    config = true,
    keys = {
      { "<leader>go", vim.cmd.Neogit, desc = "[G]it [O]pen" },
    },
  },

  -- Git diffs
  {
    "sindrets/diffview.nvim",
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          file_history_panel = {
            { "n", "K", actions.open_commit_log, { desc = "Show commit details" } },
          },
        },
      }
    end,
    keys = {
      { "<leader>gdo", vim.cmd.DiffviewOpen,  desc = "[G]it [D]iff [O]pen" },
      { "<leader>gdc", vim.cmd.DiffviewClose, desc = "[G]it [D]iff [C]lose" },
      {
        "<leader>gdh",
        function()
          vim.cmd.DiffviewFileHistory(vim.fn.expand("%"))
        end,
        desc = "Git [D]iff [H]istory",
      },
    },
  },

  {
    "akinsho/git-conflict.nvim",
    -- lazy = false,
    event = "VeryLazy",
    opts = {}
  },
}
