vim.g.mapleader = ","

-- Paste without yanking (visual mode)
vim.keymap.set("v", "<Leader>p", '"_dP', { noremap = true })
vim.keymap.set("n", "<leader>f", vim.cmd.NvimTreeFindFileToggle)
vim.keymap.set("n", "<C-n>", ":tabnew<CR>")

-- Faster escape key
for _, mode in pairs({'i', 'n', 'v', 'c'}) do
  vim.keymap.set(mode, "<C-j>", "<Esc>", { noremap = true })
end

-- Window resizing
vim.keymap.set("n", "<C-w><Up>", "<C-w>-", { noremap = true })
vim.keymap.set("n", "<C-w><C-Up>", "<C-w>-", { noremap = true })
vim.keymap.set("n", "<C-w><Down>", "<C-w>+", { noremap = true })
vim.keymap.set("n", "<C-w><C-Down>", "C-w>+", { noremap = true })
vim.keymap.set("n", "<C-PageUp>", "2<C-w>-", { noremap = true })
vim.keymap.set("n", "<C-PageDown>", "<C-w>+", { noremap = true })
vim.keymap.set("n", "<C-Home>", "2<C-w><", { noremap = true })
vim.keymap.set("n", "<C-End>", "2<C-w>>", { noremap = true })

vim.keymap.set(
  "v",
  "<leader>c",
  ":'<,'>yank | put! | '<,'>!sh -c \"perl -pe 'chomp if eof' | xclip -i -selection clipboard\""
)
