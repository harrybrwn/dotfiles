local path = require("core.util.path")

vim.g.mapleader = ","

---@param cmd string
---@param action string|function
---@param opts table|nil
local function nset(cmd, action, opts)
  vim.keymap.set("n", cmd, action, opts)
end

---create a function that runs tmux split-window
---@param size number the size of the new split tmux window
---@return function
local function window_split_fn(size)
  if os.getenv("TMUX") == nil then
    return function() end
  end
  return function()
    -- Open a tmux virticle tmux window that is 20% the size of the current pane.
    -- local file = vim.fn.expand("%")
    local dir = path.dirname(vim.api.nvim_buf_get_name(0))
    local cmd = string.format('tmux split-window -v -p %d -c "%s"', size or 30, dir)
    local handle = io.popen(cmd, 'r')
    if handle == nil then
      error('Warning: failed to execute tmux command', 2)
      return
    end
    handle:close()
  end
end

-- Paste without yanking (visual mode)
nset("<leader>f", vim.cmd.NvimTreeFindFileToggle, { desc = "[F]iletree toggle" })
nset("<leader>e", vim.cmd.TroubleToggle, { desc = "[E]rror diagnostics window toggle" })
nset("<leader>t", vim.cmd.tabnew, { desc = "[T]ab create" })
-- Git Diff Helpers
nset("<leader>gdo", vim.cmd.DiffviewOpen, { desc = "[G]it [D]iff [O]pen" })
nset("<leader>gdc", vim.cmd.DiffviewClose, { desc = "[G]it [D]iff [C]lose" })
nset("<leader>gdh", function() vim.cmd.DiffviewFileHistory(vim.fn.expand('%')) end, { desc = "Git [D]iff [H]istory" })
-- Misc
nset('<C-w>"', window_split_fn(30), { desc = "Open a tmux window below vim." })
vim.keymap.set("v", "<Leader>p", '"_dP', { noremap = true, desc = "Paste without yanking the highlighted text" })

-- Faster escape key
for _, mode in pairs({ 'i', 'n', 'v', 'c' }) do
  vim.keymap.set(mode, "<C-j>", "<Esc>", { noremap = true, desc = "remapped escape" })
end

-- Window resizing
nset("<C-w><Up>", "<C-w>-", { noremap = true })
nset("<C-w><C-Up>", "<C-w>-", { noremap = true })
nset("<C-w><Down>", "<C-w>+", { noremap = true })
nset("<C-w><C-Down>", "C-w>+", { noremap = true })
nset("<C-PageUp>", "2<C-w>-", { noremap = true })
nset("<C-PageDown>", "<C-w>+", { noremap = true })
nset("<C-Home>", "2<C-w><", { noremap = true })
nset("<C-End>", "2<C-w>>", { noremap = true })
--nset("<C-h>", "<C-w><")
--nset("<C-l>", "<C-w>>")
nset("d=", "kJ")
nset("<C-I>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.buf.format({ bufnr = bufnr })
end)

vim.keymap.set(
  "v",
  "<leader>c",
  ":'<,'>yank | put! | '<,'>!sh -c \"perl -pe 'chomp if eof' | xclip -i -selection clipboard\""
)
