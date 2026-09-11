---@meta

---@class mp.utils
local utils = {}

---@alias mp.utils.ReaddirFilter
---| '"files"'
---| '"dirs"'
---| '"normal"'
---| '"all"'

---@class mp.utils.FileInfo
---@field mode integer Protection bits.
---@field size integer Size in bytes.
---@field atime integer Last access time, as Unix epoch seconds.
---@field mtime integer Last modification time, as Unix epoch seconds.
---@field ctime integer Last metadata-change time, as Unix epoch seconds.
---@field is_file boolean Whether the path is a regular file.
---@field is_dir boolean Whether the path is a directory.

---@class mp.utils.SubprocessOptions
---@field args string[] Command and arguments.
---@field cancellable? boolean Legacy name mapped to `playback_only`.
---@field max_size? integer Legacy name mapped to `capture_size`.
---@field capture_stdout? boolean Defaults to true in `utils.subprocess`.
---@field capture_stderr? boolean
---@field stdin_data? string
---@field env? string[]
---@field detach? boolean

---@class mp.utils.SubprocessResult
---@field status integer Exit status.
---@field stdout string
---@field stderr? string
---@field error? string
---@field error_string? string
---@field killed_by_us? boolean

---Return the directory from which mpv was launched.
---@return string? cwd
---@return string? error
function utils.getcwd() end

---Enumerate entries in a directory.
---
---Returned names are directory entries only, without the containing path.
---The returned list is unsorted.
---@param path string
---@param filter? mp.utils.ReaddirFilter
---@return string[]? entries
---@return string? error
function utils.readdir(path, filter) end

---Return filesystem information for `path`.
---@param path string
---@return mp.utils.FileInfo? info
---@return string? error
function utils.file_info(path) end

---Split a path into directory and trailing filename components.
---@param path string
---@return string directory
---@return string filename
function utils.split_path(path) end

---Join two path components.
---
---If `p2` is absolute, it may be returned unchanged.
---@param p1 string
---@param p2 string
---@return string path
function utils.join_path(p1, p2) end

---Run an external process and wait until it exits.
---
---Legacy wrapper around `mp.command_native({ name = "subprocess", ... })`.
---Prefer `mp.command_native` or `mp.command_native_async` for new code.
---@param options mp.utils.SubprocessOptions
---@return mp.utils.SubprocessResult result
---@deprecated
function utils.subprocess(options) end

---Run an external process detached from mpv's control.
---
---Legacy helper.
---@param options { args: string[] }
---@deprecated
function utils.subprocess_detached(options) end

---Return the process ID of the running mpv process.
---@return integer pid
function utils.getpid() end

---Return the C process environment as an array of `NAME=value` strings.
---@return string[] environment
function utils.get_env_list() end

---Parse JSON into a Lua value.
---
---If `trail` is true, trailing non-whitespace input is accepted and returned
---as the third result.
---@param str string
---@param trail? boolean
---@return any? value
---@return string? error
---@return string? trailing
function utils.parse_json(str, trail) end

---Serialize a Lua value as JSON.
---@param value any
---@return string? json
---@return string? error
function utils.format_json(value) end

---Convert a Lua value to a human-readable string.
---
---Unlike plain `tostring`, tables and their contents are formatted recursively.
---@param value any
---@return string
function utils.to_string(value) end

return utils
