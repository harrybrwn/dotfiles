---@meta

---@class mp
---@field script_name string
---@field keep_running boolean
---@field use_suspend boolean
---@field MAP table
---@field ARRAY table
---@field UNKNOWN_TYPE table
mp = {}

---Registers a callback to be run on a timer.
---@param seconds number The duration to wait before executing the function.
---@param fn function The callback function.
---@return table timer # A timer object handle.
function mp.add_timeout(seconds, fn) end

---@class mp.Timer
---@field stop  fun(self: mp.Timer) Pause the timer, remembering elapsed time
---@field kill  fun(self: mp.Timer) Stop and reset the timer
---@field resume  fun(self: mp.Timer) Start or unpause the timer
---@field is_enabled  fun(self: mp.Timer): boolean  Check if the timer is active
---@field timeout integer timeout in seconds
---@field oneshot boolean

---Call fn repeatedly every seconds seconds.
---@param seconds any
---@param fn fun()
---@param disabled? boolean
---@return mp.Timer
function mp.add_periodic_timer(seconds, fn, disabled) end

---@param timer mp.Timer
function mp.cancel_timer(timer) end

---Get the value of a property as a string.
---@param name string The property name.
---@param def? string Optional default value if the property is missing.
---@return string|nil value # The property value, or def/nil on error.
function mp.get_property(name, def) end

---Set a property to the given string value. Returns true on success, nil, error
---on failure.
---@param name string
---@param value any
---@return nil, string
function mp.set_property(name, value) end

---Set a property to a given native Lua type (tables, booleans, etc.).
---@param name string The property name.
---@param value any The value to set.
---@return boolean? success # True on success, nil on error.
function mp.set_property_native(name, value) end

---@param command string
---@return true|nil
function mp.command(command) end

---Runs an mpv command (similar to input.conf bindings).
---@param table string[] An array of strings representing the command and arguments.
---@return boolean? success # True on success, nil on error.
function mp.commandv(table) end

--- See mpv(1)
---@class mp.CommandOpts
---@field name string Name of the mpv command to run.
---@field args string[] Arguments passed to the command.
---@field timeout? integer Max execution time in seconds before termination.
---@field capture_stdout? boolean
---@field capture_stderr? boolean
---@field playback_only? boolean If true, the process will be killed when playback stops.
---@field stdin_data? string
---@field env? string[]
---@field detach? boolean

---@class mp.CommandResult
---@field status integer The exit code of the process.
---@field stdout string
---@field stderr string
---@field error_string string An mpv-specific error code string.
---@field killed_by_us boolean True if the process was terminated by timeout or kill signal.

---@param opts mp.CommandOpts
---@return mp.CommandResult
function mp.command_native(opts) end

---@param opts mp.CommandOpts
---@param callback fun(success: boolean, result: mp.CommandResult, err: any|nil)
function mp.command_native_async(opts, callback) end

---@class mp.KeyBindingFlags
---@field repeatable? boolean Enable key repeat
---@field complex?    boolean Call fn on key down, repeat, and up events
---@field scalable?   boolean Enable scaling (only with complex = true)

---Register fn to be called when key is pressed. key uses the same names as
---input.conf (e.g. "ctrl+a", "F5"). name is a unique symbolic name for the
---binding.
---@param key string
---@param name string
---@param callback fun(): nil
---@param flags? mp.KeyBindingFlags
function mp.add_key_binding(key, name, callback, flags) end

---Remove a binding registered with mp.add_key_binding or
---mp.add_forced_key_binding by name.
---@param name string
function mp.remove_key_binding(name) end

function mp.flush_key_bindings() end

---Returns the script’s internal name (e.g. my_script)
---@return string
function mp.get_script_name() end

---Returns the script directory path (directory scripts only)
---@return string
function mp.get_script_directory() end

---Returns current mpv internal time in seconds
---@return integer
function mp.get_time() end

---Show text on the OSD; duration in seconds
---@param msg string
---@param timeout? integer
function mp.osd_message(msg, timeout) end

---Read a value from --script-opts
---@param key string
---@return string|nil
function mp.get_opt(key) end

---@alias mp.EventName
---| '"start-file"'       Fired before a file starts loading. Fields: playlist_entry_id.
---| '"file-loaded"'      Fired after a file is loaded and playback begins.
---| '"end-file"'         Fired after a file is unloaded.
---| '"seek"'             Fired when the player seeks (including internal seeks).
---| '"playback-restart"' Fired at start of playback after a seek or file load.
---| '"shutdown"'         Fired when mpv is quitting. Normally handled automatically.
---| '"log-message"'      Fired for log messages enabled with mp.enable_messages(level). Fields: prefix, level, text.
---| '"property-change"'  Fired when an observed property changes. Fields: name, data.
---| '"video-reconfig"'   Fired on video output or filter reconfiguration.
---| '"audio-reconfig"'   Fired on audio output or filter reconfiguration.

---Call fn(event) when the named event occurs. event is a table with at least an
---event field (the event name string). Returns true if the event exists, false
---otherwise.
---@param name mp.EventName
---@param fn fun(event)
function mp.register_event(name, fn) end

---Remove all event handlers equal to fn. Uses Lua == comparison — be careful
---with closures.
---@param fn fun(event)
function mp.unregister_event(fn) end

---@alias mp.HookType
---| '"on_load"'	            Before a file is opened
---| '"on_load_fail"'	        After a file fails to open
---| '"on_preloaded"'	        After open, before track selection
---| '"on_loaded"'	          After tracks selected, before playback starts
---| '"on_unload"'	          Before a file is closed
---| '"on_before_start_file"'	Before start-file event
---| '"on_after_end_file"'	  After end-file event

---@param type mp.HookType
---@param priority  integer is an integer; 50 is the recommended neutral default. Lower values run first.
---@param fn fun(hook: any)
function mp.add_hook(type, priority, fn) end

---Example mp.find_config_file("mpv.conf")
---@param filename string
---@return string|nil
function mp.find_config_file(filename) end

---@return string
function mp.get_script_directory() end

---@class mp.Overlay
---@field data string
---@field res_x integer
---@field res_y integer
---@field z integer
---@field compute_bounds boolean
---@field hidden boolean
---@field update fun(self: mp.Overlay)
---@field remove fun(self: mp.Overlay)

---Create an overlay.
---@param format string
---@return mp.Overlay
function mp.create_osd_overlay(format) end

---returns tuple with (width, height, aspect)
---@return integer, integer, integer
function mp.get_osd_size() end
