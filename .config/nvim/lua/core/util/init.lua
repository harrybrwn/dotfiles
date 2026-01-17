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
---@param dir string
---@return table
function M.listdir(dir)
  local file = io.popen("/bin/ls -1A " .. dir, "r")
  if file == nil then
    return {}
  end
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  file:close()
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
  opts = vim.tbl_deep_extend('keep', opts, {
    parents = false,
    mode = nil,
    verbose = false,
  })
  if opts == nil then
    error("mkdir opts should not be nil")
    return
  end
  local cmd = { "mkdir" }
  if opts.parents then
    table.insert(cmd, "--parents")
  end
  if opts.mode ~= nil then
    table.insert(cmd, "--mode=" .. opts.mode)
  end
  if opts.verbose then
    table.insert(cmd, "--verbose")
  end
  table.insert(cmd, path)
  local cmdstr = table.concat(cmd, ' ')
  local proc = io.popen(cmdstr)
  if proc == nil then
    error(string.format('failed to execute "%s"', cmdstr))
    return
  end
  proc:close()
end

return M
