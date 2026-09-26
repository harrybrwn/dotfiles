mp.utils = require("mp.utils")
mp.msg = require("mp.msg")

local dam = "dam"

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

---@return string|nil
local function get_tags()
  local res = mp.command_native({
    name = "subprocess",
    args = { dam, "tags", "--no-pager", "-c1" },
    capture_stdout = true,
    capture_stderr = false,
    playback_only = false,
  })
  if res == nil or res.status ~= 0 then
    return nil
  end
  return res.stdout
end

---@param s string
---@return string
local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

---@param s string
---@return table<string>
local function split(s)
  local lines = {}
  -- [^\r\n]+ matches one or more characters that are NOT newlines
  for line in s:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  return lines
end

---@param items string[]
local function dmenu(items)
  local rofi_res = mp.command_native({
    name = "subprocess",
    args = { "rofi", "-dmenu", "-multi-select" },
    capture_stdout = true,
    stdin_data = table.concat(items, "\n"),
    playback_only = true, -- if playback stops, this process should be killed
  })
  if rofi_res.status ~= 0 then
    mp.osd_message("Failed to get prompt", 2)
    return nil
  end
  if #rofi_res.stdout == 0 then
    mp.osd_message("No tag", 2)
    return nil
  end
  local raw_results = split(trim(rofi_res.stdout))
  local res = {}
  for _, raw in pairs(raw_results) do
    table.insert(res, trim(raw))
  end
  return res
end

function _G.GetArgs(fun)
  local args = {}
  local hook = debug.gethook()
  ---@diagnostic disable-next-line: unused-vararg
  local argHook = function(...)
    local info = debug.getinfo(3)
    if 'pcall' ~= info.name then return end
    for i = 1, math.huge do
      local name, _ = debug.getlocal(2, i)
      if '(*temporary)' == name then
        debug.sethook(hook)
        error('')
        return
      end
      table.insert(args, name)
    end
  end
  debug.sethook(argHook, "c")
  pcall(fun)
  return args
end

function _G.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ', '
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local function is_in_dam_dir()
  local dir = mp.utils.getcwd()
  if dir == nil then
    return false
  end
  while dir ~= "/" do
    if file_exists(mp.utils.join_path(dir, "dam.toml")) then
      return true
    end
    local base, _ = mp.utils.split_path(dir)
    base = string.gsub(base, "/$", "")
    if base == "." then
      base = "/"
    end
    dir = base
  end
  return false
end

---@param filename string
---@param cb fun(tags: string[])
local function async_get_tags(filename, cb)
  mp.command_native_async(
    {
      name = "subprocess",
      args = {
        "curl", "--get", "-Ssf",
        "--data-urlencode", string.format("path=%s", filename),
        "localhost:4433/tags",
      },
      capture_stdout = true,
      playback_only = false,
    },
    function(success, res, err)
      if not success or err ~= nil then
        mp.osd_message("failed command 'dam tags -F'", 3)
        return
      end
      if res.status ~= 0 then
        mp.osd_message("failed to get tags", 3)
        return
      end
      if #res.stdout == 0 then
        mp.osd_message("no tags", 3)
        return
      end
      local response = mp.utils.parse_json(res.stdout)
      cb(response["tags"])
    end
  )
end

local all_tags = {}
local in_dam_dir = nil

mp.register_event("start-file", function(event)
  if not file_exists(mp.utils.join_path(os.getenv("HOME") or "", ".local/bin/dam")) then
    return
  end
  if in_dam_dir == nil then
    in_dam_dir = is_in_dam_dir()
  end
  if #all_tags > 0 or not in_dam_dir then
    return
  end
  mp.msg.info("starting server")
  mp.command_native_async(
    {
      name = "subprocess",
      args = { dam, "server" },
      capture_stdout = true,
      capture_stderr = true,
      playback_only = false,
    },
    function(success, res, err)
      mp.msg.info("stopped server")
      print(string.format(
        "success=%s, res=%s, err=%s", tostring(success), tostring(res), tostring(err)
      ))
      print(string.format("status=%d", res.status))
    end
  )
  mp.osd_message("server is ready", 3)
  mp.msg.info(string.format("%s, in_dam_dir=%s", dump(event), tostring(in_dam_dir)))
  local raw = get_tags()
  if raw == nil then
    return
  end
  all_tags = {}
  for line in raw:gmatch("[^\r\n]+") do
    table.insert(all_tags, trim(line))
  end
end)

local kb = {}

function kb.get_dam_tags()
  if not in_dam_dir then
    return
  end
  local filename = mp.get_property("path")
  if filename == nil then
    mp.osd_message("could not get path")
    return
  end
  async_get_tags(filename, function(tags)
    if #tags == 0 then
      mp.osd_message("no tags", 2)
    else
      mp.osd_message(string.format("%s", table.concat(tags, "\n")), 5)
    end
  end)
end

function kb.add_dam_tags()
  if not in_dam_dir then
    return
  end
  local current_filename = mp.get_property("path")
  local tags = dmenu(all_tags)
  if tags == nil then
    return
  end
  mp.osd_message(string.format("adding tag '%s'", table.concat(tags, ", ")), 2)
  mp.command_native_async(
    {
      name = "subprocess",
      args = {
        "curl", "-Ssf", "-XPOST",
        "--data", mp.utils.format_json({ path = current_filename, tags = tags }),
        "localhost:4433/tag"
      },
      playback_only = false,
      capture_stdout = true,
    },
    function(success, result, err)
      print(string.format(
        "success=%s, res=%s, err=%s", tostring(success), tostring(result), tostring(err)
      ))
      print(string.format("status=%d", result.status))
      mp.osd_message(string.format(
        "Success:\nadded tags \"%s\"\nto \"%s\"", table.concat(tags, ","), current_filename), 3)
    end
  )
end

function kb.show_path()
  local current_filename = mp.get_property("path")
  mp.osd_message(string.format("path %s", current_filename), 3)
end

function kb.remove_tag()
  if not in_dam_dir then
    return
  end
  local current_filename = mp.get_property("path")
  if current_filename == nil then
    mp.osd_message("could not get path")
    return
  end
  async_get_tags(current_filename, function(tags)
    local to_remove = dmenu(tags)
    if to_remove == nil then
      return
    end
    local res = mp.command_native({
      name = "subprocess",
      args = {
        "curl", "-XDELETE", "-Ssf",
        "--data", mp.utils.format_json({ path = current_filename, tags = to_remove }),
        "localhost:4433/tag"
      },
      playback_only = false,
      capture_stdout = true,
    })
    if res.status ~= 0 then
      mp.osd_message("failed to remove tags: " .. res.stdout, 5)
      return
    end
    mp.osd_message("Removed " .. table.concat(to_remove, ", "), 5)
  end)
end

mp.add_key_binding("alt+t", "add-tags", kb.add_dam_tags)
mp.add_key_binding("ctrl+t", "get-dam-file-tags", kb.get_dam_tags)
mp.add_key_binding("alt+p", "show-path", kb.show_path)
mp.add_key_binding("alt+r", "remote-tag", kb.remove_tag)
