local helpers = require("core.helpers")

return {
	-- Commenting utility
	{
		-- "gc" and "gcc" to comment lines and regions
		"numToStr/Comment.nvim",
		tag = "v0.8.0",
		lazy = false,
		opts = {},
	},

	-- Language Server
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			-- Snippets
			{ "L3MON4D3/LuaSnip", tag = "v2.0.0" }, -- Required
			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},

	-- Use LSP for inlay hints.
	{ "lvimuser/lsp-inlayhints.nvim", opts = {}, lazy = false },

	-- Use treesitter to autoclose html tags
	{ "windwp/nvim-ts-autotag", lazy = false },

	-- null-ls auto formatting
	{
		"jose-elias-alvarez/null-ls.nvim",
		enabled = true,
		event = "BufRead",
		opts = function()
			return require("core.plugins.null-ls")
		end,
		-- must load after lsp-zero.setup
		dependencies = { "VonHeikemen/lsp-zero.nvim" },
	},

	-- Display lsp diagnostics
	{
		"folke/trouble.nvim",
		tag = (vim.version().minor >= 10 and "v3.4.3" or "v2.10.0"),
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "BufRead",
		opts = {
			height = 5,
			auto_preview = true,
			cycle_results = false,
		},
		keys = {
			{ "<leader>e", vim.cmd.TroubleToggle, desc = "[E]rror diagnostics window toggle" },
			{ "<leader>xx", vim.cmd.TroubleToggle, desc = "[E]rror diagnostics window toggle" },
			{
				"<leader>E",
				function()
					vim.diagnostic.open_float(0, {
						scope = "line",
						format = function(diag)
							local level = "w"
							if diag.severity == 1 then
								level = "e"
							end
							return string.format(
								"[%s] %s (%s)",
								level,
								--diag.lnum + 1,
								--diag.col + 1,
								diag.message,
								diag.source
							)
						end,
					})
				end,
				desc = "Show [E]rror in a popup",
			},
		},
	},

	-- Function signature pop-up
	{ "ray-x/lsp_signature.nvim", event = "VeryLazy", opts = {} },

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},

	-- Snippets for completion
	{
		"L3MON4D3/LuaSnip",
		tag = "v2.3.0",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},

	-- Syntax parsers and highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.2",
		config = helpers.with_notify_disabled(function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end),
	},

	-- Extra tab features
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
}
