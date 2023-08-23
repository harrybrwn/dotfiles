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
  local file = io.popen('/bin/ls -1A ' .. dir, 'r')
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

return M
