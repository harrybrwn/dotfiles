return {
	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		enabled = function()
			local name = vim.fn.hostname()
			return name ~= "thinkpadx1"
		end,
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
			copilot_node_command = vim.fn.expand("$NVM_DIR") .. "/versions/node/v18.18.0/bin/node",
			filetypes = {
				help = false,
			},
		},
	},

	-- Markdown live previews in a web browser
	{
		"iamcco/markdown-preview.nvim",
		enabled = false,
		cmd = {
			"MarkdownPreview",
			"MarkdownPreviewStop",
			"MarkdownPreviewToggle",
		},
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
