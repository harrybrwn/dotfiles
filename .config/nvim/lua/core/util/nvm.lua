local path = require("core.util.path")

local M = {}

function M.dir()
  return vim.fn.expand("$NVM_DIR")
end

function M.default(dir)
  local f = io.open(path.join(dir, "alias/default"), "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  return string.gsub(content, "%s+$", "")
end

return M
