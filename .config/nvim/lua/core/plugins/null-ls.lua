local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

local fmt = null_ls.builtins.formatting
local diags = null_ls.builtins.diagnostics

local opts = {
	sources = {
		fmt.gofmt,
		fmt.goimports_reviser,
		fmt.goimports,
		fmt.golines,
		fmt.stylua,
		fmt.rustfmt,
		fmt.nixfmt,
		fmt.terraform_fmt,
		fmt.trim_whitespace.with({
			filetypes = {
				"sh",
				"toml",
				"make",
				"conf",
				"tmux",
				"go",
				"rust",
				"javascript",
				"typescript",
			},
		}),
		-- fmt.jq,
		diags.actionlint,
		diags.buf,
		diags.eslint.with({
			condition = function(utils)
				return utils.root_has_file({
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
					"eslint.config.mts",
					"eslint.config.cts",
				})
			end,
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
}

-- If lsp-zero is being used, this should be called after lsp-zero's setup function is called.
return opts
