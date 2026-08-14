local shortname = {
  [vim.diagnostic.severity.ERROR] = 'e',
  [vim.diagnostic.severity.WARN] = 'w',
  [vim.diagnostic.severity.INFO] = 'i',
  [vim.diagnostic.severity.HINT] = 'h',
}

---@type LazyPluginSpec
return {
  -- Display lsp diagnostics
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Trouble",
  init = function()
    vim.diagnostic.config({
      virtual_text = true, -- a very small inline popup to the right of a diagnostic
      signs = true,
    })
  end,

  ---@diagnostic disable: unused-local
  opts = function(plugin, options)
    -- options.keys = {
    --   ["<tab>"] = "jump",
    -- }
  end,

  keys = {
    {
      "<leader>e",
      "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
      desc = "[e]rror diagnostics for current buffer",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "[E]rror diagnostics window toggle",
    },
    {
      "<leader>E",
      function()
        vim.diagnostic.open_float(nil, {
          scope = "line",
          format = function(diag)
            local level = shortname[diag.severity]
            local ns = vim.diagnostic.get_namespace(diag.namespace)
            return string.format(
              "[%s] %s (%s) (%s)",
              level,
              --diag.lnum + 1, diag.col + 1,
              diag.message,
              diag.source,
              ns.name
            )
          end,
        })
      end,
      desc = "Show [E]rror in a popup",
    },
  },
}
