local util = require("core.util")

local M = {}

M.filepath_sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os ~= "windows" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

--- Remove the right-most path element of a filepath.
--- Equivalent to dirname in POSIX systems
---@param str string the path string
function M.dirname(str)
  -- TODO use M.filepath_sep instead of a hardcodded '/'
  if str:match(".-/.-") then
    local name = string.gsub(str, "(.*/)(.*)", "%1")
    return name
  else
    return ''
  end
end

--- Join any number of elements into a valid filepath.
---@param ... any
---@return string
function M.join(...)
  return table.concat({ ... }, M.filepath_sep)
end

---split a filepath into a table of parts
---@param str string
---@return table
function M.split(str)
  return util.split(str, M.filepath_sep)
end

return M
