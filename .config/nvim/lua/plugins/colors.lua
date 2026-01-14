-- Themes
--
-- Look for more good ones here https://github.com/rockerBOO/awesome-neovim#tree-sitter-supported-colorscheme
return {
  {
    "EdenEast/nightfox.nvim", -- nightfox nordfox terafox duskfox carbonfox
    lazy = true,
    priority = 1000,
  },
  "ntk148v/vim-horizon",
  "rebelot/kanagawa.nvim",
  "shaunsingh/nord.nvim",
  "sainnhe/everforest",

  { "ellisonleao/gruvbox.nvim", lazy = true,         priority = 1000, config = true },
  "shaunsingh/solarized.nvim",
  --"maxmx03/solarized.nvim",
  "sainnhe/sonokai",
  { "catppuccin/nvim",          name = "catppuccin", priority = 1000 },
  "ntk148v/komau.vim",
  "lunarvim/templeos.nvim",
  -- { "yorickpeterse/nvim-grey", lazy = false, priority = 1000 },
  {
    "navarasu/onedark.nvim",
    opts = { style = "darker" },
  },
  {
    "mcchrish/zenbones.nvim",
    enabled = true,
    dependencies = { "rktjmp/lush.nvim" },
  },

  {
    "aktersnurra/no-clown-fiesta.nvim",
    opts = {
      transparent = false, -- Enable this to disable the bg color
      styles = {
        -- You can set any of the style values specified for `:h nvim_set_hl`
        type = { bold = true },
        lsp = { underline = true },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night", -- storm, moon, night, day
    },
  },
  {
    "svrana/neosolarized.nvim",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    opts = {
      comment_italics = false,
      background_set = true,
    },
  },
  {
    "AlexvZyl/nordic.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      -- override = {
      --   FoldColumn = { fg = "none", bg = "none" },
      --   Visual = { bg = 0x111111 },
      -- },
      ---@diagnostic disable-next-line: unused-local
      on_highlight = function(highlights, palette)
        highlights.FoldColumn = { fg = "none", bg = "none" }
        highlights.Visual = { bg = 0x111111 }
      end,
      cursorline = {
        -- Bold font in cursorline.
        bold = false,
        -- Bold cursorline number.
        bold_number = true,
        -- Avialable styles: 'dark', 'light'.
        theme = "dark",
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.7,
      },
      ts_context = {
        dark_background = true,
      },
    },
  },
  { "marko-cerovac/material.nvim" },
  { "tanvirtin/monokai.nvim" },
  {
    'everviolet/nvim',
    name = 'evergarden',
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      theme = {
        variant = 'spring', -- 'winter'|'fall'|'spring'|'summer'
        accent = 'green',
      },
      editor = {
        transparent_background = true,
        sign = { color = 'none' },
        float = {
          color = 'mantle',
          invert_border = false,
        },
        completion = {
          color = 'surface0',
        },
      },
    }
  },
}
