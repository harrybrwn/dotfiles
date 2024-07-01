local plugins = {}
local version = vim.version()

if version.major == 0 and version.minor >= 10 then
	table.insert(plugins, {
		"OXY2DEV/markview.nvim",
		enabled = true,
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("markview").setup()
		end,
	})
end

return plugins
