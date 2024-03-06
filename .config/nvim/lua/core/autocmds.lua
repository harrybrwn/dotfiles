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

-- Save and restore cursor location.
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
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
