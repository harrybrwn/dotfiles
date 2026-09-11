---@meta

local msg = {}

---@alias mp.msg.LogLevel
---| '"fatal"'
---| '"error"'
---| '"warn"'
---| '"info"'
---| '"v"'
---| '"debug"'
---| '"trace"'

---@param level mp.msg.LogLevel
---@param ... any
function msg.log(level, ...) end

---@param ... any
function msg.verbose(...) end

---@param ... any
function msg.info(...) end

---@param ... any
function msg.warn(...) end

---@param ... any
function msg.error(...) end

---@param ... any
function msg.fatal(...) end

---@param ... any
function msg.debug(...) end

---@param ... any
function msg.trace(...) end

return msg
