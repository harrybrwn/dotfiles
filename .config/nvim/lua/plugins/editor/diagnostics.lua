return {
  -- Display lsp diagnostics
  {
    "folke/trouble.nvim",
    tag = (
      vim.version().minor >= 10
      --and "v3.4.3"
      and "v3.7.1"
      or "v2.10.0"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    event = "BufRead",
    opts = {
      height = 5,
      keys = {
        ["<tab>"] = "jump",
      }
    },
    keys = {
      { "<leader>e",  "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "[E]rror diagnostics window toggle" },
      { "<leader>xx", vim.cmd.TroubleToggle,                            desc = "[E]rror diagnostics window toggle" },
      {
        "<leader>E",
        function()
          vim.diagnostic.open_float(nil, {
            scope = "line",
            format = function(diag)
              local level = "w"
              if diag.severity == 1 then
                level = "e"
              end
              return string.format(
                "[%s] %s (%s)",
                level,
                --diag.lnum + 1,
                --diag.col + 1,
                diag.message,
                diag.source
              )
            end,
          })
        end,
        desc = "Show [E]rror in a popup",
      },
    },
  },

}
