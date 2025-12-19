local helpers = {}

-- This doesn't work for some reason
--
---@param ft string | table
---@param tabwidth number
function helpers.tabsize(ft, tabwidth)
  --print("filetype", ft, "tabwidth", tabwidth)
  vim.api.nvim_create_autocmd({ "Filetype" }, {
    pattern = ft,
    callback = function()
      vim.opt_local.tabstop = tabwidth
      vim.opt_local.shiftwidth = tabwidth
      vim.opt_local.softtabstop = tabwidth
    end,
  })
end

---Pretty print lua table
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

---Don't use this. Use vim.api.nvim_list_bufs
function helpers.list_buffers()
  local len = 0
  local buffers = {}
  for buffer = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(buffer) ~= 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end
  return buffers
end

function _G.test_list_bufs()
  vim.print(helpers.list_buffers())
  vim.print(vim.api.nvim_list_bufs())
end

-- Returns a function that wraps fn so it is called with vim.notify disabled
-- temporarily.
--
---@param fn function
---@return function
function helpers.with_notify_disabled(fn)
  return function()
    local notify = vim.notify
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(_, _, _) end
    fn()
    vim.notify = notify
  end
end

--- Function equivalent to basename in POSIX systems
--@param str the path string
function helpers.basename(str)
  local name = string.gsub(str, "(.*/)(.*)", "%2")
  return name
end

return helpers
