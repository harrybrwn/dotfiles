local editorconfig = require("editorconfig")

if GoplsEditorconfig == nil then
  GoplsEditorconfig = {}
end

-- Adds tags to the internal configuration.
---@param tags string
local function add_tags(tags)
  local tag_list = vim.split(tags, ',')
  if GoplsEditorconfig.build_tags == nil then
    GoplsEditorconfig.build_tags = tag_list
  else
    for _, tag in pairs(tag_list) do
      table.insert(GoplsEditorconfig.build_tags, tag)
    end
  end
end

-- on_attach function for gopls only
local function gopls_on_attach(client, _)
  if client.config.settings.gopls == nil then
    return
  end
  local gopls = client.config.settings.gopls
  local conf = GoplsEditorconfig
  if #conf.build_tags > 0 then
    local flag = "-tags=" .. table.concat(conf.build_tags, ',')
    if gopls.buildFlags ~= nil then
      table.insert(gopls.buildFlags, flag)
    else
      gopls.buildFlags = { flag }
    end
  end
end

local M = {}

-- Setup all the custom editorconfig properties.
function M.setup()
  -- editorconfig.properties.custom_property = function(bufnr, val, opts) end
  editorconfig.properties.go_build_tags = function(_, val, _)
    add_tags(val)
  end
end

-- on_attach will use the internal configuration and convert it to lsp settings.
--
---@param client any
---@param bufnr number
function M.on_attach(client, bufnr)
  local name = client.config.name
  if name == 'gopls' then
    gopls_on_attach(client, bufnr)
  end
end

return M
