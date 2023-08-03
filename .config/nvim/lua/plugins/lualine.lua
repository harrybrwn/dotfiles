-- lualine configuration
--
-- To setup fonts, download a font from
-- https://www.nerdfonts.com/font-downloads and do the following setup. Unzip
-- the file, copy the fonts to either '~/.local/share/fonts',
-- '/usr/share/fonts', or '~/.fonts' and the run `fc-cache -fv` and set the
-- font in your terminal.

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = ' ', right = ' ' },
        section_separators = { left = ' ', right = ' ' },
        disable_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divid_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      }
    }
  }
}

