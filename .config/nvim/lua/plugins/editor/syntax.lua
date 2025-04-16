return {
  -- Syntax parsers and highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.3",
    enabled = true,
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
          --"html",   -- commented out because it keeps crashing
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
        ignore_install = {
          "html", -- don't install because it keeps crashing
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
  }
}
