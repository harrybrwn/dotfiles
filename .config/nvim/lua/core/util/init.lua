local M = {}

---Split a string
---@param str string
---@param sep string
---@return table
function M.split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for s in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

---List the files in a directory.
---@param path string
---@return table
function M.listdir(path)
  local dir = vim.uv.fs_opendir(path)
  if not dir then
    return {}
  end
  local res = {}
  local entries
  while true do
    entries = dir:readdir()
    if entries == nil or #entries < 1 then
      break
    end
    for _, e in ipairs(entries) do
      table.insert(res, e.name)
    end
  end
  dir:closedir()
  return res
end

---returns true if s ends with the exact suffix
---@param s string
---@param suffix string
---@return boolean
function M.endswith(s, suffix)
  return s:sub(- #suffix) == suffix
end

--- Extend a list-like table.
---@param a table list to be extended
---@param b table list of elements to be put into a
function M.extend(a, b)
  for _, elem in pairs(b) do
    table.insert(a, elem)
  end
end

--- @return string|nil
function M.machine_id()
  local f = io.open("/etc/machine-id", "r")
  if f == nil then
    return nil
  end
  local content = f:read("*a")
  f:close()
  local s = string.gsub(content, "%s+$", "")
  return s
end

---Create directories.
---@param path string
---@param opts? table
function M.mkdir(path, opts)
  path = vim.fs.normalize(path, { expand_env = true })
  opts = vim.tbl_deep_extend('keep', opts, {
    parents = false,
    ---@type any
    mode = nil,
    verbose = false,
  })
  if opts == nil then
    error("mkdir opts should not be nil")
    return
  end
  local mode = 420 -- base 10 of 0o644
  if opts.mode ~= nil then
    if type(opts.mode) == 'string' then
      mode = tonumber(opts.mode, 8) -- convert from octal
    elseif type(opts.mode) == 'number' then
      mode = opts.mode
    end
  end
  if opts.parents then
    for parent in vim.fs.parents(path) do
      if vim.uv.fs_stat(parent) then
        vim.uv.fs_mkdir(parent, mode)
      else
        break
      end
    end
  end
  local ok = vim.uv.fs_mkdir(path, mode)
  if ok then
    error('failed to create ' .. path)
  end
  return ok
end

return M
