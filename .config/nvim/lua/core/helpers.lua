vim.cmd("filetype plugin on")

local helpers = {}

-- This doesn't work for some reason
function helpers.tabsize(ft, tabwidth)
  --print("filetype", ft, "tabwidth", tabwidth)
  vim.api.nvim_create_autocmd(
    {'Filetype'},
    {
      pattern = ft,
      callback = function()
        vim.opt_local.tabstop = tabwidth
        vim.opt_local.shiftwidth = tabwidth
        vim.opt_local.softtabstop = tabwidth
      end
    }
  )
end

return helpers
