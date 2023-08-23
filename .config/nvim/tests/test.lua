local util = require("core.util")

local testdir = "./tests"

local function run_spec(name)
  print(name, '\n')
  if not util.endswith(name, "_spec.lua") then
    error("not a valid test spec filename")
  end
  local testfile = testdir .. "/" .. name
  print("Running", testfile, "\n")
  dofile(testfile)
end

-- Find tests
local tests = {}
if #arg > 0 then
  -- Add command line arguments without checking if they are _spec.lua
  for i, a in pairs(arg) do
    if i == 0 then
      goto continue
    end
    table.insert(tests, a)
    ::continue::
  end
else
  for _, f in pairs(util.listdir(testdir)) do
    if util.endswith(f, "_spec.lua") then
      table.insert(tests, f)
    end
  end
end

if #tests < 1 then
  error("no tests to run")
end

for _, test in pairs(tests) do
  run_spec(test)
end
