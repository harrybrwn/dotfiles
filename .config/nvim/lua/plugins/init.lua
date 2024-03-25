return {
	-- Commenting utility
	{
		-- "gc" and "gcc" to comment lines and regions
		"numToStr/Comment.nvim",
		tag = "v0.8.0",
		lazy = false,
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		--event = "InsertEnter",
		enabled = true,
		opts = {
			disable_filetype = {
				"TelescopePrompt",
				"spectre_panel",
				"scheme",
				"lisp",
				"text",
				"markdown",
			},
			enable_check_bracket_line = false,
			check_ts = true,
			ts_config = {
				-- go = { 'string', 'comment' },
				-- lua = { 'string', 'comment' },
				["*"] = { "string" }, -- don't pair when in these tree-sitter nodes
				basic = false, -- don't check tree-sitter for basic
			},
		},
		init = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			local ts_conds = require("nvim-autopairs.ts-conds")
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")

			-- press % => %% only while inside a comment or string
			npairs.add_rules({
				-- Rule('```', '```', 'markdown'):only_cr(),
				Rule("then", "end", "lua")
					:with_pair(ts_conds.is_not_ts_node({ "string", "comment" }))
					:end_wise(function(opts)
						-- Add any context checks here, e.g. line starts with "if"
						return string.match(opts.line, "^%s*if") ~= nil
					end),
			})
		end,
	},

	-- Use treesitter to autoclose html tags
	{ "windwp/nvim-ts-autotag", lazy = false },

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
	},

	-- Display lsp diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { height = 5 },
		event = "BufRead",
	},
}
