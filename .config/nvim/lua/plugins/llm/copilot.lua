-- Github Copilot
local nvm = require("core.util.nvm")
local path = require("core.util.path")

local settings = {
  local_ollama = false,
}

local function make_opts(model)
  local nvm_dir = nvm.dir()
  return {
    copilot_model = model,
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<S-Tab>",
        dismiss = "<C-[>",
      },
    },
    panel = {
      enabled = true,
      auto_refresh = true,
    },
    copilot_node_command = path.join(nvm_dir, "versions/node", nvm.default(nvm_dir), "bin/node"),
    filetypes = {
      help = false,
    },
  }
end

local plugin = {
  "zbirenbaum/copilot.lua",
  enabled = true,
  lazy = false,
  cmd = "Copilot",
  opts = function() return make_opts("") end,
}

if settings.local_ollama then
  plugin.init = function()
    -- ollama-copilot must be running
    -- see lua/core/plugins/lsp.lua
    vim.g.copilot_proxy = "https://127.0.0.1:11435"
    vim.g.copilot_proxy_strict_ssl = false
  end
  plugin.opts = function() return make_opts("ollama-copilot") end
  plugin.enabled = function()
    -- local disabled = require("core.plugins.custom-editorconfig").lsp_disabled.copilot
    -- return not disabled
    return vim.fn.executable("/usr/local/bin/nvidia-smi") == 1
  end
end

return plugin
