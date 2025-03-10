local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local path = require("core.util.path")

if not configs.copilot_ollama then
  -- TODO auto install with
  -- go install -trimpath -ldflags '-s -w' github.com/bernardo-bruning/ollama-copilot@latest
  configs.copilot_ollama = {
    default_config = {
      name = 'copilot_ollama',
      cmd = { "ollama-copilot" },
      filetypes = { "lua", "go", "typescript", "typescriptreact", "javascript", "yaml" },
      root_dir = vim.fn.getcwd(),
    },
  }
end

local function rust_analyzer()
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
          closingBraceHints = { enable = false }, -- hints after a closing brace
          implicitDrops = { enable = false },
        },
      },
    },
  })
end

local function gopls()
  local lsputil = require("lspconfig/util")
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
end

local function tsserver()
  -- See configuration does here:
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
  lspconfig.ts_ls.setup({
    -- This on_attach function does *not* override the one setup by lsp-zero at
    -- the top of this file.
    on_attach = function(client)
      -- Disable auto formating
      --client.server_capabilities.documentFormattingProvider = false
      --client.server_capabilities.documentRangeFormattingProvider = false
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
end

local function yamlls()
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
          -- kubernetes = {
          --   "k8s/**/*.{yaml,yml}", -- basically only for my homelab lol
          --   "hack/**/*.{yaml,yml}",
          -- },
          -- kubernetes = "*.{yaml,yml}",
          ["http://json.schemastore.org/github-workflow"] = ".github/workflows/**/*.{yaml,yml}",
          ["http://json.schemastore.org/github-action"] = {
            "/.github/actions/**/*.{yaml,yml}",
            -- "/.github/action*.{yml,yaml}",
            -- "/.github/**/*.{yaml,yml}",
          },
          ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
          ["http://json.schemastore.org/chart.json"] = "Chart.yaml",
          ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] =
          'docker-compose*.{yml,yaml}',
          -- ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] =
          -- "argocd-application.yaml",
        },
        schemaDownload = { enable = true },
        validate = true,
      },
    },
  })
end

local function astro()
  lspconfig.astro.setup({
    init_options = {
      typescript = {
        -- tsdk = vim.fs.normalize("~/Library/pnpm/global/5/node_modules/typescript/lib"),
        tsdk = vim.fs.normalize("node_modules/typescript/lib"),
      },
    },
  })
end

local function helm_ls()
  lspconfig.helm_ls.setup({
    settings = {
      ['helm-ls'] = {
        yamlls = {
          enabled = true,
          path = "yaml-language-server",
        }
      }
    }
  })
end

local M = {}

function M.setup_cmp()
  local lsp = require("lsp-zero")
  lsp.extend_cmp()
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
end

function M.setup(opts)
  local lsp = require("lsp-zero")
  local fmtgroup = vim.api.nvim_create_augroup("LspFormatting", {})
  local auto_format = opts.auto_format
  local ensure_installed = opts.ensure_installed

  ---@param client vim.lsp.Client
  ---@param bufnr number
  lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    require("core.plugins.custom-editorconfig").lsp_on_attach(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)

    lsp.default_keymaps({ buffer = bufnr })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })

    -- Auto formatting
    if client.supports_method("textDocument/formatting") and auto_format[vim.bo.filetype] then
      vim.api.nvim_clear_autocmds({
        group = fmtgroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmtgroup,
        buffer = bufnr,
        callback = function()
          if auto_format[vim.bo.filetype] then
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end)

  require("mason").setup({})
  require("mason-lspconfig").setup({
    -- look at https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md
    ensure_installed = ensure_installed,
    handlers = {
      -- this first function is the "default handler"
      -- it applies to every language server without a "custom handler"
      function(server_name)
        lspconfig[server_name].setup({})
      end,
      lua_ls = function()
        local lua_opts = lsp.nvim_lua_ls()
        local xdg_config_home = os.getenv("XDG_CONFIG_HOME")
        if xdg_config_home ~= nil then
          table.insert(
            lua_opts.settings.Lua.workspace.library,
            path.join(xdg_config_home, "LuaLS")
          )
        end
        table.insert(
          lua_opts.settings.Lua.workspace.library,
          "/usr/share/LuaLS"
        )
        lspconfig.lua_ls.setup(lua_opts)
      end,
      helm_ls = helm_ls,
      rust_analyzer = rust_analyzer,
      gopls = gopls,
      yamlls = yamlls,
      -- tsserver = tsserver,
      ts_ls = tsserver,
      astro = astro,
    },
  })

  if not require("core.plugins.custom-editorconfig").lsp_disabled.copilot_ollama then
    print("copilot_ollama.setup")
    lspconfig.copilot_ollama.setup({})
  end
end

return M
