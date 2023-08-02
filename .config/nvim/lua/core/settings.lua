-- Set tab width to 2 for these filetypes.
vim.api.nvim_create_autocmd(
  {'FileType'},
  {
    pattern = {
      'lua',
      'sh',
      'javascript',
      'typescript',
      'yaml',
      'nix',
      'vim',
    },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end
  }
)

-- Save and restore cursor location.
vim.api.nvim_create_autocmd(
  {'BufReadPost'},
  {
    pattern = {'*'},
    callback = function()
      local ft = vim.opt_local.filetype:get()
      -- don't apply to git messages
      if (ft:match('commit') or ft:match('rebase')) then
        return
      end
      -- get position of last saved edit
      local markpos = vim.api.nvim_buf_get_mark(0,'"')
      local line = markpos[1]
      local col = markpos[2]
      -- if in range, go there
      if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
        vim.api.nvim_win_set_cursor(0,{line,col})
      end
    end
  }
)
