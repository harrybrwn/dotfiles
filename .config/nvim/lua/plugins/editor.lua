local helpers = require("core.helpers")

return {
  -- Commenting utility
  {
    -- "gc" and "gcc" to comment lines and regions
    "numToStr/Comment.nvim",
    tag = "v0.8.0",
    lazy = false,
    opts = {},
  },

  -- Use treesitter to autoclose html tags
  { "windwp/nvim-ts-autotag", lazy = false },

  -- null-ls auto formatting
  {
    "nvimtools/none-ls.nvim",
    enabled = true,
    event = "BufRead",
    opts = function(_, _)
      -- return require("core.plugins.null-ls")
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting
      local diags = null_ls.builtins.diagnostics
      return {
        sources = {
          fmt.stylua,
          fmt.nixfmt,
          fmt.terraform_fmt,
          diags.actionlint,
          diags.buf,
        },
      }
    end,
    -- must load after lsp-zero.setup
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
  },

  -- Display lsp diagnostics
  {
    "folke/trouble.nvim",
    tag = (vim.version().minor >= 10 and "v3.4.3" or "v2.10.0"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    event = "BufRead",
    opts = {
      height = 5,
      auto_preview = true,
      cycle_results = false,
    },
    keys = {
      { "<leader>e", "<cmd>Trouble diagnostics toggle<cr>", desc = "[E]rror diagnostics window toggle" },
      { "<leader>xx", vim.cmd.TroubleToggle, desc = "[E]rror diagnostics window toggle" },
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

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },

  -- Snippets for completion
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.3.0",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- Syntax parsers and highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.2",
    -- build = helpers.with_notify_disabled(function()
    -- 	-- pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    -- 	require("nvim-treesitter.install").update({ with_sync = true })()
    -- end),
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      local ts_parsers = require("nvim-treesitter.parsers")
      ts_parsers.get_parser_configs().gotmpl = {
        install_info = {
          url = "https://github.com/ngalaiko/tree-sitter-go-template",
          branch = "master",
          files = { "src/parser.c" },
          --requires_generate_from_grammar = false,
        },
        filetype = "gotmpl",
        used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
      }

      configs.setup({
        ensure_installed = {
          "go",
          "gomod",
          "gosum",
          "gowork",
          "gotmpl", -- added in this file
          -- web
          "html",
          "css",
          "http", -- https://learn.microsoft.com/en-us/aspnet/core/test/http-files
          "javascript",
          "typescript",
          "tsx",
          "astro",
          "vue",
          -- misc languages
          "python",
          "rust",
          "sql",
          "lua",
          "nix",
          "dockerfile",
          "make",
          "c",
          "cpp",
          "query",
          "elixir",
          "vim",
          "vimdoc",
          -- random file formats
          "json",
          "yaml",
          "toml",
          "git_config",
          "gitcommit",
          "gitignore",
          -- hashicorp's universe
          "hcl",
          "terraform",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Extra tab features
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
  },
}
