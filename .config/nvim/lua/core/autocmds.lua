local sessions = require("core.plugins.sessions")

sessions.setup_autocmds()

-- Set tab width to 2 for these filetypes.
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "lua",
    "sh",
    "javascript",
    "typescript",
    "yaml",
    "nix",
    "vim",
    "html",
    "astro",
    "terraform",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- For some reason my formatoptions are being overridden and I have to set them
-- in an autocmd.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

vim.cmd([[ autocmd BufRead,BufEnter *.astro set filetype=astro ]])

-- Auto-reload buffer when a file changes on disk
vim.opt.autoread = true
vim.cmd("autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif")
vim.cmd(
  [[autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]]
)

-- vim.api.nvim_add_user_command("Clear", function(opts)
-- 	vim.print(opts)
-- end, { nargs = 1 })

vim.api.nvim_buf_create_user_command(0, "Clear", function(_opts)
  for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
    print(bufnr, vim.api.nvim_buf_is_loaded(bufnr), vim.api.nvim_buf_get_name(bufnr))
  end
end, {})

-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_user_command("PubDate", function(_opts)
  local pos = vim.fn.getcurpos()
  local buf = vim.fn.getbufinfo({ buflisted = 1 })[1]
  local lnum = pos[2]
  local col = pos[3]
  local handle = io.popen("node -e 'console.log(new Date());'", "r")
  if handle == nil then
    error("Warning: failed to execute node command", 2)
    return
  end
  local date_str = handle:read("*l")
  handle:close()
  -- local end_col = col + string.len(date_str)
  local end_col = -1
  vim.api.nvim_buf_set_text(
    buf.bufnr,
    lnum - 1,
    col,
    lnum - 1,
    end_col,
    { date_str }
  )
end, {})
