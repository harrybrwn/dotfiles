require("nvim-treesitter.configs").setup {
  ensure_installed = {
    -- god tier
    'c',
    'cpp',
    -- go
    'go',
    'gomod',
    -- web
    'typescript',
    'javascript',
    'html',
    'json',
    'yaml',
    'astro',
    'tsx',
    -- misc languages
    'python',
    'rust',
    'sql',
    'lua',
    'nix',
    'dockerfile',
    'git_config',
    'gitcommit',
    'gitignore',
    -- hashicorp
    'hcl',
    'terraform',
    -- markdown
    'markdown',
    'markdown_inline',
  },
  highlight = { enable = true },
  indent = { enable = true },
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
