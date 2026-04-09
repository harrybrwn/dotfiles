return {
  { import = "plugins.llm.avante" },
  { import = "plugins.llm.codecompanion" },
  { import = "plugins.llm.copilot" },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              mode = "n", desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            mode = "n", desc = "Toggle Claude Code" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       mode = "n", desc = "Focus Claude Code" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   mode = "n", desc = "Resume Claude Code" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", mode = "n", desc = "Continue Claude Code" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", mode = "n", desc = "Select Claude Code model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       mode = "n", desc = "Add current buffer to Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "Send to Claude Code" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude Code",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff for Claude Code" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff for Claude Code" },
      { "<leader>aq", "<C-\\><C-n>q",                  desc = "Quit Claude Code and close all diff windows" }
    },
  },

  {
    "github/copilot.vim",
    enabled = false,
    lazy = false,
  }
}
