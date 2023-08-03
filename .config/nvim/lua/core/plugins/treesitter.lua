require("nvim-treesitter.configs").setup {
  ensure_installed = {
    -- god tier
    'c',
    -- go
    'go',
    'gomod',
    'gosum',
    'gowork',
    -- web
    'typescript',
    'javascript',
    'html',
    'astro',
    'tsx',
    'http', -- https://learn.microsoft.com/en-us/aspnet/core/test/http-files
    -- misc languages
    'python',
    'rust',
    'sql',
    'lua',
    'nix',
    'dockerfile',
    'make',
    -- random file formats
    'json',
    'yaml',
    'toml',
    'git_config',
    'gitcommit',
    'gitignore',
    -- hashicorp's universe
    'hcl',
    'terraform',
    -- markdown
    'markdown',
    'markdown_inline',
    -- actual dog doodoo
    'cpp',
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  additional_vim_regex_highlighting = false,
}
