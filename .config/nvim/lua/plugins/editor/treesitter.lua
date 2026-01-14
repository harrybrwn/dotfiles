local langs = {
  "go", "gomod", "gosum", "gowork",
  "gotmpl", -- added in this config
  "rust",
  "python",
  "lua",
  "sql",
  "bash",
  "sh",
  "markdown",
  "nix",
  "elixir",
  "haskell",
  "c",
  "cpp",
  "asm",
  "nasm",
  "r",
  "vim",

  -- web
  "html",
  "css",
  "javascript",
  "typescript",
  "typescriptreact",
  "javascriptreact",
  "vue",
  "astro",
  "svelte",

  -- tools
  "make",
  "proto",
  "dockerfile",
  "terraform",
  "jq",
  "gitconfig",
  "gitrebase",
  "gitcommit",
  "gitignore",
  "sshconfig",
  "nginx",
  "tmux",
  "gpg",

  -- data
  "json", "yaml", "json5", "jsonnet", "toml", "xml",

  -- doc
  "vimdoc",
  -- misc
  "query",
}

return {
  -- Syntax parsers and highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    -- For a more stable build, use 'tag = "v0.10.0"'
    branch = "main",
    -- Explicitly load for these filetypes to prevent the highlight delay that
    -- looks really ugly.
    ft = langs,
    cmd = {
      "TSUpdate",
      "TSInstall",
      "TSUninstall",
      "TSInstallFromGrammar",
      "TSLog",
    },
    build = ":TSUpdate",
    opts = {},
    config = function(_, opts)
      require('nvim-treesitter.parsers').gotmpl = {
        install_info = {
          url = "https://github.com/ngalaiko/tree-sitter-go-template",
          branch = "master",
          files = { "src/parser.c" },
          --requires_generate_from_grammar = false,
        },
        filetype = "gotmpl",
        used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
      }
      vim.schedule(function()
        local ts = require("nvim-treesitter")
        local parsers = {
          "markdown_inline",
          "luadoc",
        }
        local parsernames = {}
        for _, l in pairs(langs) do
          local lang = vim.treesitter.language.get_lang(l)
          if not parsernames[lang] and lang ~= nil then
            parsers[#parsers + 1] = lang
            parsernames[lang] = true
          end
        end
        ts.install(parsers)
        ts.update(parsers)
      end)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = langs,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      require("nvim-treesitter").setup(opts)
    end,
  },
}
