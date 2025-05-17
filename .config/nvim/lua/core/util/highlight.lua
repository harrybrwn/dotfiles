local M = {}

function M.transparent_background()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' }) -- Non-current windows
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
  -- Telescope
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
  -- For nvim-tree specifically
  vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
end

return M
