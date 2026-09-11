---@meta

---@class mp.input
local input = {}

---@class mp.input.InputOpts
---@field prompt?          string Text shown before the input field
---@field items?           any[]
---@field submit?          fun(index: integer) Called when user presses Enter
---@field edited?          fun(text: string) Called on each keystroke
---@field complete?        fun(text_before_cursor: string, respond)  Called for tab completion
---@field close?           fun(text: string, cursor_pos: integer)    Called when console closes
---@field keep_open?       boolean Keep console open after submit (default: false)
---@field default_text?    string  Pre-fill the input field
---@field cursor_position? integer Initial cursor position (1-based)
---@field history_path?    string  Path for persisting input history

---Open an input prompt.
---@param opts mp.input.InputOpts
function input.get(opts) end

---@param opts mp.input.InputOpts
function input.select(opts) end

---Close the active input console
function input.terminate() end

---Append a line to the log buffer
---@param message any
---@param style any
---@param terminal_style any
function input.log(message, style, terminal_style) end

---@param log any
function input.set_log(log) end

---@param message any
function input.log_error(message) end

return input
