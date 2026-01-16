local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1
  },
}

---@param opts Options
local function open_floating_term(opts)
  opts = opts or {}
  -- Floating window dimensions
  local width = vim.tbl_get(opts, "win", "width") or math.floor(vim.o.columns * 0.8)
  local height = vim.tbl_get(opts, "win", "height") or math.floor(vim.o.lines * 0.8)
  --local width = opts.win.width or math.floor(vim.o.columns * 0.8)
  --local height = opts.win.height or math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Window options
  local winopts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  local buf = nil
  if vim.api.nvim_buf_is_valid(state.floating.buf) then
    buf = state.floating.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win = vim.api.nvim_open_win(buf, true, winopts)

  vim.keymap.set("t", opts.keys.normal, "<C-\\><C-n>", { buffer = buf })
  vim.keymap.set("n", opts.keys.quit, function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })
  return { buf = buf, win = win }
end

---@param opts Options
local function toggle_terminal(opts)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = open_floating_term(opts)
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.fn.jobstart(vim.o.shell, {
        term = true,
        on_exit = function()
          vim.api.nvim_buf_delete(state.floating.buf, {})
          -- TODO: Do we need to call vim.api.nvim_win_close(state.floating.win, false)?
        end,
      })
      --To start in insert mode, run: vim.cmd("startinsert")
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

---@class Options
---@field keys KeysOptions
---@field win WinOptions

---@class WinOptions
---@field height? number
---@field width? number

---@class KeysOptions
---@field quit string
---@field normal string

---@type Options
local DEFAULT_OPTS = {
  keys = {
    -- close the terminal window
    quit = "q",
    -- exit insert mode into "normal" mode.
    normal = "<Esc><Esc>",
  },
  win = {}
}

---@param opts? Options
function M.setup(opts)
  opts = opts or DEFAULT_OPTS
  vim.api.nvim_create_user_command("Term", function()
    toggle_terminal(opts)
  end, {})
end

-- return M
M.setup()
