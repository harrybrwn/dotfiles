local path = require("core.util.path")
local ts_parsers = require("nvim-treesitter.parsers")

local cli_installed = true
local xdg_data_home = os.getenv("XDG_DATA_HOME")
if xdg_data_home == nil then
  xdg_data_home = path.join(os.getenv("HOME"), ".cache")
end
local parser_dir = path.join(xdg_data_home, "tree-sitter/parsers")
local options = {
  ensure_installed = {
    -- go
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

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  parser_install_dir = cli_installed and parser_dir or nil,

  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "comment" then
        print("parsing comments:", lang)
      elseif lang == "json" then
        if vim.api.nvim_buf_line_count(bufnr) > 50000 then
          return true
        end
      end
      return false
    end,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<c-backspace>",
    },
  },
  additional_vim_regex_highlighting = false,
}

local parser_configs = ts_parsers.get_parser_configs()
parser_configs.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    branch = "master",
    files = { "src/parser.c" },
    -- requires_generate_from_grammar = false,
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}
--vim.cmd [[autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif]]

if cli_installed then
  vim.opt.rtp:prepend(parser_dir)
end

require("nvim-treesitter.configs").setup(options)
