return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		defaults = {
			mappings = {
				i = { ["<C-j>"] = "close" },
				n = { ["<C-j>"] = "close" },
			},
			file_ignore_patterns = { ".git" },
		},
		pickers = {
			live_grep = {
				additional_args = function(opts)
					print(opts.cwd)
					return { "--hidden" }
				end,
			},
		},
	},
	init = function()
		require("core.plugins.telescope").init()
	end,
}
