local shortname = {
  [vim.diagnostic.severity.ERROR] = 'e',
  [vim.diagnostic.severity.WARN] = 'w',
  [vim.diagnostic.severity.INFO] = 'i',
  [vim.diagnostic.severity.HINT] = 'h',
}

return {
  -- Display lsp diagnostics
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  init = function()
    vim.diagnostic.config({
      virtual_text = true,
      float = true,
      signs = true,
      -- virtual_text = {
      --   source = true,
      --   -- source = "always", -- Or "if_many" to show only if there are multiple clients
      -- },
      -- float = {
      --   source = true,
      --   -- source = "always", -- Forces the source to show up in the hover popup window
      -- },
    })
  end,
  opts = function(_, opts)
    opts.height = 5
    opts.keys = {
      ["<tab>"] = "jump",
    }
    local trouble = require("trouble")
    local symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      -- The following line is needed to fix the background color
      -- Set it to the lualine section you want to use
      hl_group = "lualine_c_normal",
    })
    opts.sections = {
      lualine_c = {
        symbols.get,
        cond = symbols.has,
      }
    }
    -- table.insert(opts, { sections = { lualine_c = {} } })
    -- table.insert(opts.sections.lualine_c, {
    --   symbols.get,
    --   cond = symbols.has,
    -- })
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
