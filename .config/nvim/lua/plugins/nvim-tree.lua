local custom = require("core.plugins.filetree")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set("n", "g0", vim.cmd.NvimTreeFindFile, { noremap = true })

-- nvim-tree: An alternate file explorer
return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		enabled = true,
		lazy = false,
		opts = {
			view = {
				side = "left",
				width = "15%",
				-- width = {
				--   min = 40,
				--   max = "20%",
				-- },
				centralize_selection = false, -- center with 'zz' when entering the tree
				cursorline = true, -- show line at the cursor
				preserve_window_proportions = false, -- don't readjust window sizes
				float = {
					enable = false,
					quit_on_focus_loss = true,
				}, -- view in floating window
			},
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			modified = {
				enable = true,
				show_on_open_dirs = false,
			},
			renderer = {
				highlight_modified = "none", -- none|icon|name|all
				highlight_git = "icon", -- none|icon|name|all
				highlight_diagnostics = "none",
				highlight_opened_files = "none", -- none|icon|name|all
				group_empty = true, -- group empty folders as one pathname
				indent_markers = {
					enable = false,
				},
				special_files = {
					"Cargo.toml",
					"Makefile",
					"README.md",
					"readme.md",
					"go.mod",
				},
			},
			tab = { sync = { open = true, close = true } },
			diagnostics = { enable = true },
			update_focused_file = {
				enable = true, -- move cursor to current open file
				ignore_list = { "node_modules", ".git" },
			},
			filesystem_watchers = {
				ignore_dirs = { "node_modules", ".git" },
			},
			on_attach = custom.on_attach,
		},
	},
}
