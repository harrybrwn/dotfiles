vim.keymap.set("v", "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>")
vim.keymap.set("v", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>")

return {
	-- Git Diff icons in gutter
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				-- 	add = { text = "│" },
				-- 	change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 650,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d %I:%M%p> - <summary>",
			-- current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		},
		keys = {
			{ "<leader>gB", "<cmd>Gitsigns blame<cr>" },
			{ "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>lh" },
			{ "<leader>gdw", "<cmd>Gitsigns toggle_word_diff<cr>" },
			-- { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>" },
			-- { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>" },
		},
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			--"ibhagwan/fzf-lua", -- optional
		},
		lazy = false,
		config = true,
	},

	-- Git diffs
	{
		"sindrets/diffview.nvim",
		lazy = false,
		opts = function()
			local actions = require("diffview.actions")
			return {
				keymaps = {
					file_history_panel = {
						{ "n", "K", actions.open_commit_log, { desc = "Show commit details" } },
					},
				},
			}
		end,
		keys = {
			{ "<leader>gdo", vim.cmd.DiffviewOpen, desc = "[G]it [D]iff [O]pen" },
			{ "<leader>gdc", vim.cmd.DiffviewClose, desc = "[G]it [D]iff [C]lose" },
			{
				"<leader>gdh",
				function()
					vim.cmd.DiffviewFileHistory(vim.fn.expand("%"))
				end,
				desc = "Git [D]iff [H]istory",
			},
		},
	},

	-- Git Blame
	{
		"f-person/git-blame.nvim",
		lazy = true,
		enabled = false,
		opts = { enabled = false },
		-- keys = {
		-- 	{ "<leader>gb", vim.cmd.GitBlameToggle },
		-- },
	},
}
