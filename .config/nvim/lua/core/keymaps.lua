local path = require("core.util.path")
local tmux = require("core.plugins.tmux_session")

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
  if not tmux.in_tmux() then
    return function() end
  end
  return function()
    if tmux.term_is_open() then
      tmux.select_term()
    else
      tmux.open_term(size)
    end
  end
end

-- Paste without yanking (visual mode)
nset("<leader>f", vim.cmd.NvimTreeFindFileToggle, { desc = "[F]iletree toggle" })
-- nset("<leader>e", vim.cmd.TroubleToggle, { desc = "[E]rror diagnostics window toggle" })
-- nset("<leader>E", popup_diagnostics, { desc = "Show [E]rror in a popup" })
nset("<leader>t", vim.cmd.tabnew, { desc = "[T]ab create" })
-- Misc
nset('<C-w>"', window_split_fn(30), { desc = "Open a tmux window below vim." })
vim.keymap.set("v", "<Leader>p", '"_dP', { noremap = true, desc = "Paste without yanking the highlighted text" })

-- Faster escape key
for _, mode in pairs({ "i", "n", "v", "c" }) do
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
nset("d=", "kJ")
nset("<C-I>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.buf.format({ bufnr = bufnr })
end)
nset("<Leader>F", function()
  vim.cmd("echo expand('%')")
end)
nset("<Leader>ct", vim.cmd.tabclose, { noremap = true })
nset("<C-p>", "<cmd><C-p>")

-- vim.keymap.set(
--   "v",
--   "<leader>c",
--   ":'<,'>yank | put! | '<,'>!sh -c \"perl -pe 'chomp if eof' | xclip -i -selection clipboard\"<CR>"
-- )
vim.keymap.set("v", "<leader>c", '"+y', { desc = "Copy selection to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard" })
vim.keymap.set("n", "<leader>R", ":LspRestart<CR>", { desc = "[R]estart the current LSP" })
