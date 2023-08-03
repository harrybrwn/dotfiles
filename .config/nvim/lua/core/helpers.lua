vim.cmd("filetype plugin on")

local helpers = {}

-- This doesn't work for some reason
--
---@param ft string | table
---@param tabwidth number
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

---Pretty print lua table
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end

return helpers
