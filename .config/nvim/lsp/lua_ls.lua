local path = require("core.util.path")

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local settings = {
  diagnostics = {
    globals = { "vim" },
  },
  type = {
    castNumberToInteger = true,
    inferParamType = true,
  },
  runtime = {
    version = 'LuaJIT',
    path = runtime_path,
  },
  telemetry = {
    enable = false,
  },
  workspace = {
    checkThirdParty = false,
    library = {
      vim.env.VIMRUNTIME,
      "${3rd}/luv/library",
      "/usr/share/LuaLS",
    },
  }
}

local xdg_config_home = os.getenv("XDG_CONFIG_HOME")
if xdg_config_home ~= nil then
  table.insert(
    settings.workspace.library,
    path.join(xdg_config_home, "LuaLS")
  )
end

return {
  cmd = { "lua-language-server" },
  filetype = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  settings = {
    Lua = settings,
  }
}
