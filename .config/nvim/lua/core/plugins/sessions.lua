local M = {}

function M.setup_autocmds()
  local viewaugroup = vim.api.nvim_create_augroup("SaveFolds", {})
  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    group = viewaugroup,
    pattern = "*",
    callback = function()
      local ft = vim.opt_local.filetype:get()
      -- don't apply to git messages
      if ft:match("commit") or ft:match("rebase") then
        return
      end
      vim.cmd("silent! mkview")
    end,
  })
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = viewaugroup,
    pattern = "*",
    callback = function()
      local ft = vim.opt_local.filetype:get()
      -- don't apply to git messages
      if ft:match("commit") or ft:match("rebase") then
        return
      end
      vim.cmd("silent! loadview")
    end,
  })
end

--- Save and restore cursor location.
function M.restore_cursor()
  vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    ---@diagnostic disable-next-line: unused-local
    callback = function(event)
      local ft = vim.opt_local.filetype:get()
      -- don't apply to git messages
      if ft:match("commit") or ft:match("rebase") then
        return
      end
      -- get position of last saved edit
      local markpos = vim.api.nvim_buf_get_mark(0, '"')
      local line = markpos[1]
      local col = markpos[2]
      -- if in range, go there
      if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
        vim.api.nvim_win_set_cursor(0, { line, col })
      end
    end,
  })
end

return M
