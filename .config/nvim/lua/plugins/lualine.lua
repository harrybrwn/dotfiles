-- lualine configuration
--
-- To setup fonts, download a font from
-- https://www.nerdfonts.com/font-downloads and do the following setup. Unzip
-- the file, copy the fonts to either '~/.local/share/fonts',
-- '/usr/share/fonts', or '~/.fonts' and the run `fc-cache -fv` and set the
-- font in your terminal.

local filename_section = {
  'filename',
  path = 1,                -- relative pathname
  symbols = {
    modified = '[+]',      -- Text to show when the file is modified.
    readonly = '[RO]',     -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
    newfile = '[New]',     -- Text to show for newly created file before first write
  }
}

local fileformat = {
  'fileformat',
  symbols = {
    --unix = '', -- e712
    --dos = '', -- e70f
    mac = '', -- e711
    unix = 'lf',
    dos = 'crlf',
  }
}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = {
      extentions = { "nvim-tree" },
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = ' ', right = ' ' },
        section_separators = { left = ' ', right = ' ' },
        disabled_filetypes = {
          "NvimTree",
          "DiffviewFiles",
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divid_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { filename_section },
        lualine_x = { 'encoding', fileformat, 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename_section },
        lualine_x = { 'encoding', fileformat },
        lualine_y = { 'location' },
        lualine_z = {}
      },
    }
  }
}
