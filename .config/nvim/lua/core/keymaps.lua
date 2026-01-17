local tmux = require("core.plugins.tmux_session")

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
  return function()
    if not tmux.in_tmux() then
      return
    end
    if tmux.term_is_open() then
      tmux.select_term()
    else
      tmux.open_term(size)
    end
  end
end

-- Paste without yanking (visual mode)
nset("<leader>t", vim.cmd.tabnew, { desc = "[T]ab create" })
-- Misc
nset('<C-w>"', window_split_fn(30), { desc = "Open a tmux window below vim." })
vim.keymap.set("v", "<Leader>p", '"_dP', { noremap = true, desc = "Paste without yanking the highlighted text" })

-- Faster escape key
vim.keymap.set("i", "<C-j>", "<Esc>", { noremap = true, desc = "remapped escape" })
vim.keymap.set("n", "<C-j>", "<Esc>", { noremap = true, desc = "remapped escape" })
vim.keymap.set("v", "<C-j>", "<Esc>", { noremap = true, desc = "remapped escape" })
vim.keymap.set("c", "<C-j>", "<Esc>", { noremap = true, desc = "remapped escape" })

-- Window resizing
nset("<C-w><Up>", "<C-w>-", { noremap = true })
nset("<C-w><C-Up>", "<C-w>-", { noremap = true })
nset("<C-w><Down>", "<C-w>+", { noremap = true })
nset("<C-w><C-Down>", "C-w>+", { noremap = true })
nset("<C-PageUp>", "<C-w>-", { noremap = true })
nset("<C-PageDown>", "<C-w>+", { noremap = true })
nset("<C-Home>", "2<C-w><", { noremap = true })
nset("<C-End>", "2<C-w>>", { noremap = true })
nset("d=", "kJ")
nset("<Leader>F", function()
  vim.cmd("echo expand('%')")
end)
nset("<C-p>", "<cmd><C-p>")

-- vim.keymap.set(
--   "v",
--   "<leader>c",
--   ":'<,'>yank | put! | '<,'>!sh -c \"perl -pe 'chomp if eof' | xclip -i -selection clipboard\"<CR>"
-- )
vim.keymap.set("v", "<leader>c", '"+y', { desc = "Copy selection to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard" })
vim.keymap.set("n", "<leader>R", ":LspRestart<CR>", { desc = "[R]estart the current LSP" })
vim.keymap.set("n", "<leader>D", "<cmd>read!node -e 'console.log(new Date)'<cr>")

-- Tab shortcuts
vim.keymap.set("n", "<leader>ct", vim.cmd.tabclose, { desc = "[C]lose [T]ab", noremap = true })
vim.keymap.set("n", "<A-.>", "gt", { desc = "Prev tab", noremap = true, silent = true })
vim.keymap.set("n", "<A-,>", "gT", { desc = "Prev tab", noremap = true, silent = true })
vim.keymap.set("n", "<A->>", "<cmd>tabmove +1<cr>", { desc = "Move tab up", noremap = true, silent = true })
vim.keymap.set("n", "<A-<>", "<cmd>tabmove -1<cr>", { desc = "Move tab back", noremap = true, silent = true })
