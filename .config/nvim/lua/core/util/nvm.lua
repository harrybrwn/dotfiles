local M = {}

function M.dir()
  return vim.fn.expand("$NVM_DIR")
end

function M.default(dir)
  local f = io.open(vim.fs.joinpath(dir, "alias/default"), "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  return string.gsub(content, "%s+$", "")
end

return M
