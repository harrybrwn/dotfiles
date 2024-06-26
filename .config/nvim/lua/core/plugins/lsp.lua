local lsp = require("lsp-zero").preset({})
local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")

---@param client lsp.Client
---@param bufnr number
lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings to learn the available actions
	require("core.plugins.custom-editorconfig").lsp_on_attach(client, bufnr)
	require("lsp-inlayhints").on_attach(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
end)

lsp.ensure_installed({
	-- Languages/Frameworks
	"pyright", -- python
	"gopls", -- golang
	"golangci_lint_ls",
	"rust_analyzer", -- rust
	"clangd", -- c/c++
	"sqlls", -- sql
	--'rnix', -- nix
	"nil_ls", -- nix
	"lua_ls", -- lua
	"html", -- html
	"astro", -- astro.js
	"verible", -- SystemVerilog
	"asm_lsp", -- GAS/NASM/Go assembly
	"tsserver", -- typescript
	"eslint", -- web stuff
	"cssls", -- css
	--'eslint_d',
	"volar", -- vue

	-- Configuration/Tools
	"ansiblels", -- ansible
	"terraformls", -- terraform
	"dockerls", -- docker
	"bufls", -- protobuf
	"docker_compose_language_service", -- docker-compose
	"yamlls", -- yaml
	"jsonls", -- json

	-- Not supported by ensure_installed
	-- "stylua",
})

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

lspconfig.rust_analyzer.setup({
	settings = {
		-- https://rust-analyzer.github.io/manual.html
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			-- auto import settings.
			imports = {
				granularity = {
					group = "crate",
				},
				prefix = "plain", -- no prefix restrictions
			},
			procMacro = { enable = true },
			inlayHints = {
				maxLength = 50, -- default 25
				typeHints = {
					enable = true,
					hideNamedConstructor = true,
				},
				parameterHints = { enable = false },
				closingBraceHints = { enable = false }, -- hints after a closing brace '}'
				implicitDrops = { enable = false },
			},
		},
	},
})

lspconfig.gopls.setup({
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = lsputil.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = false,
			-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
			analyses = {
				unusedparams = true,
				nilness = true,
				unusedwrite = true,
			},
			staticcheck = true,
		},
	},
})

lspconfig.yamlls.setup({
	settings = {
		yaml = {
			trace = { server = "verbose" },
			format = {
				enable = false,
			},
			-- hover = true,
			-- completion = true,
			schemas = {
				["http://json.schemastore.org/github-workflow"] = "/.github/workflows/*",
				["http://json.schemastore.org/github-action"] = {
					"/.github/actions/**/*.{yaml,yml}",
					"/.github/action*.{yml,yaml}",
				},
				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
				["http://json.schemastore.org/chart.json"] = "Chart.yaml",
				kubernetes = "**/k8s/**/*.{yaml,yml}",
			},
			schemaDownload = { enable = true },
			validate = true,
		},
	},
})

-- See configuration does here:
-- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
lspconfig.tsserver.setup({
	-- This on_attach function does *not* override the one setup by lsp-zero at
	-- the top of this file.
	on_attach = function(client)
		-- Disable auto formating
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		javascript = {
			format = {
				semicolons = "insert",
			},
		},
		typescript = {
			format = {
				semicolons = "insert",
			},
		},
	},
})

lsp.extend_cmp()
lsp.setup()
require("lsp_signature").setup({})

local cmp = require("cmp")

cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- { name = "buffer" },
		-- { name = "path" },
	}),
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- `Tab` key to confirm completion
		["<Tab>"] = cmp.mapping.confirm({ select = false }),
		-- ['<C-Space>'] = cmp.mapping.complete(),

		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping.scroll_docs(-1),
		["<C-e>"] = cmp.mapping.scroll_docs(1),
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

cmp.setup.filetype("gitignore", {
	sources = {
		{ name = "path" },
		{ name = "buffer" },
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "w", "wq", "Man", "!" },
			},
		},
	}),
})
