local helpers = {}

---Pretty print lua table
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

function _G.test_list_bufs()
  vim.print(helpers.list_buffers())
  vim.print(vim.api.nvim_list_bufs())
end

function _G.sleep(n) -- seconds
  local t0 = os.clock()
  while os.clock() - t0 <= n do
    -- busy waiting
  end
end

function _G.timeit(fn)
  local start = vim.loop.hrtime()
  fn()
  print('elapsed: ' .. ((vim.loop.hrtime() - start) / 1e6) .. 'ms')
end

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
---@deprecated use vim.fs.basename
function helpers.basename(str)
  -- local name = string.gsub(str, "(.*/)(.*)", "%2")
  -- return name
  return vim.fs.basename(str)
end

---@param fn? fun(mode: string|string[], lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts): boolean
function helpers.debug_keymap_set(fn)
  local km_set = vim.keymap.set
  -- function keymap.set(mode: string|string[], lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts? vim.keymap.set.Opts
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    if fn == nil or fn(mode, lhs, rhs, opts) then
      vim.notify(
        string.format(
          "vim.keymap.set(%s, %s, %s, %s)",
          vim.inspect(mode),
          vim.inspect(lhs),
          vim.inspect(rhs),
          vim.inspect(opts)
        ),
        vim.log.levels.INFO
      )
    end
    km_set(mode, lhs, rhs, opts)
  end
end

---@param fn? fun(modes: string|string[], lhs: string, opts?: vim.keymap.del.Opts): boolean
function helpers.debug_keymap_del(fn)
  local km_del = vim.keymap.del
  -- function keymap.del(modes: string|string[], lhs: string, opts?: vim.keymap.del.Opts)
  ---@param modes string|string[]
  ---@param lhs string
  ---@param opts? vim.keymap.del.Opts
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.del = function(modes, lhs, opts)
    if fn == nil or fn(modes, lhs, opts) then
      vim.notify(
        string.format(
          "vim.keymap.del(%s, %s, %s)",
          vim.inspect(modes),
          vim.inspect(lhs),
          vim.inspect(opts)
        ),
        vim.log.levels.INFO
      )
    end
    km_del(modes, lhs, opts)
  end
end

function helpers.set_keymap_debug_handlers()
  helpers.debug_keymap_set()
  helpers.debug_keymap_del()
end

return helpers
