local utils = require("mp.utils")
local input = require('mp.input')

---Ask a yes/no question with a rofi popup and return true when "Yes" is picked.
---Kept as a fallback (or if you prefer the external popup) for mpv builds without `mp.input`.
---@param question string
---@return boolean
local function confirm_rofi(question)
  local res = mp.command_native({
    name = "subprocess",
    args = {
      "rofi", "-dmenu",
      "-p", "Delete file?",
      "-mesg", question,
      "-i", -- case-insensitive matching
    },
    stdin_data = "Yes\nNo\n",
    capture_stdout = true,
    playback_only = true, -- kill rofi if playback stops
  })
  if res == nil or res.status ~= 0 then
    return false -- cancelled / dismissed
  end
  return res.stdout:match("^%s*Yes%s*$") ~= nil
end

---Show a native confirmation dialog using mpv's built-in input console.
---Falls back to rofi when `mp.input.select` is unavailable.
---@param question string
---@param cb fun(yes: boolean)
local function confirm(question, cb)
  local done = false
  local function finish(yes)
    if done then return end
    done = true
    cb(yes)
  end

  if input and input.select then
    input.select({
      prompt = question,
      items = { "Yes", "No" },
      submit = function(index)
        finish(index == 1)
      end,
      close = function()
        finish(false) -- dismissed without choosing
      end,
    })
  else
    finish(confirm_rofi(question))
  end
end

---Expand a path (handles ~, relative paths and mpv's pseudo paths).
---@param path string
---@return string
local function expand(path)
  local expanded = mp.command_native({ "expand-path", path })
  if type(expanded) == "string" and #expanded > 0 then
    return expanded
  end
  return path
end

local function delete_current_file()
  local path = mp.get_property("path")
  if path == nil or path == "" then
    mp.osd_message("Could not get path", 3)
    return
  end

  path = expand(path)

  local info = utils.file_info(path)
  if info == nil or not info.is_file then
    mp.osd_message("Not a local file: " .. path, 3)
    return
  end

  local _, filename = utils.split_path(path)
  confirm(string.format("Delete \"%s\"?", filename), function(yes)
    if not yes then
      mp.osd_message("Delete cancelled", 2)
      return
    end

    local ok, err = os.remove(path)
    if not ok then
      mp.osd_message(string.format("Failed to delete: %s", tostring(err)), 5)
      return
    end

    mp.osd_message(string.format("Deleted \"%s\"", filename), 3)

    -- Remove the now-deleted entry from the playlist and move on (or quit).
    mp.commandv("playlist-remove", "current")
    if (mp.get_property_number("playlist-count", 0) or 0) == 0 then
      mp.command("quit")
    end
  end)
end

mp.add_key_binding("alt+d", "delete-file", delete_current_file)
