local M = {}

function M.on_attach(bufnr)
	-- api.config.mappings.default_on_attach(bufnr)

	local api = require("nvim-tree.api")
	local actions = require("nvim-tree.actions")

	local function opts(desc)
		return {
			desc = "nvim-tree: " .. desc,
			buffer = bufnr,
			noremap = true,
			silent = true,
			nowait = true,
		}
	end

	-- These are my custom keymaps, to use the defaults either delete this function or use `api.config.mappings.default_on_attach`.
	vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
	--vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
	vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
	-- vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
	vim.keymap.set("n", "<leader>t", api.node.open.tab, opts("Open: New Tab"))
	vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
	vim.keymap.set("n", "<C-h>", api.node.open.horizontal, opts("Open: Horizontal Split"))
	vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
	vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
	vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
	vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
	vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "a", api.fs.create, opts("Create"))
	-- vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
	-- vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
	-- vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle Filter: No Buffer'))
	vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Filter: Git Clean"))
	vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
	vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
	vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
	vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
	vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
	-- vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
	vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
	vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
	vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
	vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
	vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
	--vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Filter: Dotfiles'))
	--vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Filter: Git Ignore'))
	vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
	vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
	vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
	vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
	vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
	vim.keymap.set("n", "q", api.tree.close, opts("Close"))
	vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
	vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
	vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
	vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
	vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
	vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
	vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
	vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
	vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "<leader>p", api.node.navigate.parent_close, opts("Close current parent folder"))
	vim.keymap.set("n", "<leader>a", function()
		actions.tree.find_file.fn()
	end, opts("Find current file"))
	vim.keymap.set("n", "<leader>H", function()
		local Path = require("plenary.path")
		local node = api.tree.get_node_under_cursor()
		local cwd = vim.loop.cwd()
		local rel_path = Path:new(node.absolute_path):make_relative(cwd)
		local item = {
			value = rel_path,
			context = {
				row = 1,
				col = 0,
			},
		}
		require("harpoon"):list():add(item)
	end, opts("[H]arpoon the file under cursor"))
end

function M.setup()
	-- Disable NetRW (vim's default file tree)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.keymap.set("n", "g0", vim.cmd.NvimTreeFindFile, { noremap = true })

	-- TODO move setup to be handled by lazyvim
	require("nvim-tree").setup({
		view = {
			side = "left", -- left|right
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
		on_attach = M.on_attach,
	})
end

return M
