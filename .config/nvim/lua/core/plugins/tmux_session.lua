local path = require("core.util.path")

local M = {}

---Check if nvim is running in tmux
---@return boolean returns true if nvim is currently running in tmux
function M.in_tmux()
  return os.getenv("TMUX") ~= nil
end

function M.term_is_open()
  local pane = vim.g.tmux_session_term_pane_id
  if pane == nil then
    return false
  end
  local cmd = string.format('tmux has-session -t %s 2>&1', pane)
  local handle = io.popen(cmd, "r")
  if handle == nil then
    return false
  end
  local raw_output = handle:read("*a")
  local output = string.gsub(raw_output, '^%s*(.-)%s*$', '%1')
  local ok = handle:close()
  if ok and output ~= string.format("can't find pane: %s", pane) then
    return true
  else
    vim.g.tmux_session_term_pane_id = nil
    return false
  end
end

function M.select_term()
  local cmd = string.format('tmux select-pane -t "%s" 2>/dev/null', vim.g.tmux_session_term_pane_id)
  local handle = io.popen(cmd, "r")
  if handle == nil then
    error("Warning: failed to execute tmux command", 2)
    return
  end
  handle:close()
end

function M.close_term()
  local cmd = string.format('tmux kill-pane -t "%s" 2>/dev/null', vim.g.tmux_session_term_pane_id)
  local handle = io.popen(cmd, "r")
  if handle == nil then
    error("Warning: failed to execute tmux command", 2)
    return
  end
  handle:close()
end

---Open a tmux virticle tmux window that is 20% the size of the current pane.
---@param size number|nil
function M.open_term(size)
  --local file = vim.fn.expand("%")
  local buf_name = vim.api.nvim_buf_get_name(0)
  local dir
  if buf_name:len() > 0 then
    dir = vim.fs.dirname(buf_name)
  else
    dir = vim.fn.getcwd()
  end
  local cmd = string.format(
    'tmux split-window -v -l %d%s -c "%s" -PF "#{pane_id}" 2>/dev/null',
    size or 30,
    "%",
    dir
  )
  local handle = io.popen(cmd, "r")
  if handle == nil then
    error("Warning: failed to execute tmux command", 2)
    return
  end

  -- local output = handle:read("*a")
  local output = string.gsub(handle:read("*a"), "%s+", "")
  vim.g.tmux_session_term_pane_id = output

  handle:close()
end

return M
