-- TODO: Migrate this to vim.lsp.config(...)
-- local configs = require("lspconfig.configs")
-- if not configs.copilot_ollama then
--   -- TODO auto install with
--   -- go install -trimpath -ldflags '-s -w' github.com/bernardo-bruning/ollama-copilot@latest
--   configs.copilot_ollama = {
--     default_config = {
--       name = 'copilot_ollama',
--       cmd = { "ollama-copilot" },
--       filetypes = { "lua", "go", "typescript", "typescriptreact", "javascript", "yaml" },
--       root_dir = vim.fn.getcwd(),
--     },
--   }
-- end

local M = {}

function M.setup_cmp()
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
      completion = cmp.config.window.bordered({
        border = "single",
      }),
      documentation = cmp.config.window.bordered({
        border = "single",
        scrollbar = true,
      }),
    },
    snippet = {
      ---@param args any
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    -- https://github.com/hrsh7th/nvim-cmp/issues/980
    -- formatting = {}
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

  vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
end

---@param bufnr number
function M.apply_lsp_key_mappings(bufnr)
end

---@param client vim.lsp.Client
---@param bufnr number
---@param fmtgroup number
local function setup_autoformat(client, bufnr, fmtgroup)
  vim.api.nvim_clear_autocmds({
    group = fmtgroup,
    buffer = bufnr,
  })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmtgroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        name = client.name,
        bufnr = bufnr,
      })
    end,
  })
end

---@deprecated Use conform.nvim instead.
function M.setup(opts)
  local fmtgroup = vim.api.nvim_create_augroup("LspFormatting", {})
  local auto_format = opts.auto_format
  local lsp_cmds = vim.api.nvim_create_augroup('my_lsp_attach', { clear = true })

  --- Custom on_attach function that will run for every LSP that is attached.
  vim.api.nvim_create_autocmd("LspAttach", {
    group    = lsp_cmds,
    desc     = "common lsp on_attach",
    callback = function(event)
      M.apply_lsp_key_mappings(event.buf)
      local client_id = vim.tbl_get(event, 'data', 'client_id')
      local client = {}
      if client_id then
        client = vim.lsp.get_client_by_id(client_id) or {}
      end
      if
          client:supports_method("textDocument/formatting", event.buf)
          and auto_format[vim.bo.filetype]
      then
        setup_autoformat(client, opts.buf, fmtgroup)
      end
    end,
  })

  -- if not require("core.plugins.custom-editorconfig").lsp_disabled.copilot_ollama then
  --   print("copilot_ollama.setup")
  --   require('lspconfig').copilot_ollama.setup({})
  -- end
end

return M
