return {
	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		lazy = false,
		cmd = "Copilot",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<S-Tab>",
					dismiss = "<C-]>",
				},
			},
			panel = {
				enabled = true,
				auto_refresh = true,
			},
			copilot_node_command = vim.fn.expand("$NVIM_DIR") .. "/versions/node/v18.18.0/bin/node",
			filetypes = {
				help = false,
			},
		},
	},
}
