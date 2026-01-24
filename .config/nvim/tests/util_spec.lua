local util = require("core.util")
local path = require("core.util.path")

local function tbl_eq(a, b)
  if #a ~= #b then
    return false
  end
  for i, v in pairs(a) do
    if v ~= b[i] then
      return false
    end
  end
  return true
end

assert(vim.fs.joinpath("a", "b", "c") == "a/b/c")
assert(vim.fs.joinpath("/a/b", "c/") == "/a/b/c/")
assert(vim.fs.dirname("/path/to/a/file") == "/path/to/a")
assert(vim.fs.dirname("/path/to/a/file") == "/path/to/a")
assert(vim.fs.dirname("") == ".")

assert(tbl_eq(path.split("/a/b/c/d"), { "a", "b", "c", "d" }))
assert(tbl_eq(path.split("/a/b/c/d/"), { "a", "b", "c", "d" }))

assert(util.endswith("123", "123"))
assert(util.endswith("123", "23"))
assert(util.endswith("123", "3"))
assert(tbl_eq(util.split("a b c", " "), { "a", "b", "c" }))

local a = { 'one', 'two', 'three' }
util.extend(a, { 'four', 'five' })
assert(a[1] == 'one')
assert(a[2] == 'two')
assert(a[3] == 'three')
assert(a[4] == 'four')
assert(a[5] == 'five')
