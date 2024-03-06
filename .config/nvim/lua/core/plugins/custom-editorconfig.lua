local editorconfig = require("editorconfig")
local table = require("table")
local shlex = require("core.util.shlex")
local util = require("core.util")

local GoplsEditorconfig = {
	analyses = {},
}

local LuaEditorconfig = {
	globals = {},
}

if YamlLSEditorConfig == nil then
	YamlLSEditorConfig = {
		disabled = false,
	}
end

if DisabledLSPEditorConfig == nil then
	DisabledLSPEditorConfig = {
		gopls = false,
		yamlls = false,
	}
end

-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
local gopls_analyses_attrs = {
	"asmdecl",
	"assign",
	"atomic",
	"atomicalign",
	"bools",
	"buildtag",
	"cgocall",
	"composites",
	"copylocks",
	"deepequalerrors",
	"defer",
	"deprecated",
	"directive",
	"embed",
	"erroras",
	"fieldalignment",
	"httpresponse",
	"ifaceassert",
	"loopclosure",
	"lostcancel",
	"nilfunc",
	"nilness", -- disabled by default
	"printf",
	"shadow", -- disabled by default
	"shift",
	"simplifycompositelit",
	"simplifyrange",
	"simplifyslice",
	"sortslice",
	"stdmethods",
	"stringintconv",
	"structtag",
	"testinggoroutine",
	"tests",
	"timeformat",
	"unmarshal",
	"unreachable",
	"unsafeptr",
	"unusedparams", -- disabled by default
	"unusedresult",
	"unusedwrite", -- disabled by default
	"useany",
	"fillreturns",
	"nonewvars",
	"noresultvalues",
	"undeclaredname",
	"unusedvariable", -- disabled by default
	"fillstruct",
	"infertypeargs",
	"stubmethods",
}

--- Convert a string to a boolean.
---@param val string
---@return boolean
local function to_bool(val)
	local s = string.lower(val)
	if s == "true" or s == "on" or s == "yes" or s == "1" then
		return true
	end
	return false
end

--- Strip the quotes off of a string because editorconfig does not.
---@param val string the raw value of the editorconfig string value.
---@return string the stripped result
local function strip_string(val)
	if val:sub(0, 1) == "'" or val:sub(0, 1) == '"' then
		val = val:sub(2)
	end
	if util.endswith(val, "'") or util.endswith(val, '"') then
		val = val:sub(1, -2)
	end
	return val
end

-- Adds tags to the internal configuration.
---@param tags string
local function add_tags(tags)
	local tag_list = vim.split(tags, ",")
	if GoplsEditorconfig.build_tags == nil then
		GoplsEditorconfig.build_tags = tag_list
	else
		for _, tag in pairs(tag_list) do
			table.insert(GoplsEditorconfig.build_tags, tag)
		end
	end
end

---@param raw string
local function add_flags(raw)
	local flags = shlex.split(raw)
	if GoplsEditorconfig.build_flags == nil then
		GoplsEditorconfig.build_flags = flags
	else
		for _, flg in pairs(flags) do
			table.insert(GoplsEditorconfig.build_flags, flg)
		end
	end
end

---@param gopls table
---@param flags table<integer, string>
local function gopls_add_flags(gopls, flags)
	if gopls.buildFlags ~= nil then
		for _, f in pairs(flags) do
			table.insert(gopls.buildFlags, f)
		end
	else
		gopls.buildFlags = flags
	end
end

---@param val string
local function yaml_add_schemas(val)
	if YamlLSEditorConfig.schemas == nil then
		YamlLSEditorConfig.schemas = {}
	end
	for _, kv in pairs(vim.split(val, ",")) do
		local parts = vim.split(kv, ":")
		if #parts ~= 2 then
			goto continue
		end
		if YamlLSEditorConfig.schemas[parts[1]] ~= nil then
			if type(YamlLSEditorConfig.schemas[parts[1]]) == "table" then
				table.insert(YamlLSEditorConfig.schemas[parts[1]], parts[1])
			else
				local current = YamlLSEditorConfig.schemas[parts[1]]
				YamlLSEditorConfig.schemas[parts[1]] = { current, parts[2] }
			end
		else
			YamlLSEditorConfig.schemas[parts[1]] = parts[2]
		end
		::continue::
	end
end

local function gopls_add_analyses(gopls, settings)
	if gopls.analyses == nil then
		gopls.analyses = {}
	end
	gopls.analyses = vim.tbl_extend("force", gopls.analyses, settings)
end

-- on_attach function for gopls only
---comment
---@param client lsp.Client
---@param _ number
local function gopls_on_attach(client, _)
	if client.config.settings.gopls == nil then
		client.config.settings.gopls = {}
	end
	local gopls = client.config.settings.gopls
	local conf = GoplsEditorconfig
	if DisabledLSPEditorConfig.gopls then
		print("stopping gopls!")
		vim.lsp.stop_client(client.id, true)
		return
	end

	if conf.build_tags ~= nil and #conf.build_tags > 0 then
		gopls_add_flags(gopls, {
			"-tags=" .. table.concat(conf.build_tags, ","),
		})
	end
	if conf.build_flags ~= nil and #conf.build_flags > 0 then
		gopls_add_flags(gopls, conf.build_flags)
	end

	if conf.analyses ~= nil then
		gopls_add_analyses(gopls, conf.analyses)
	end
	if conf.complete_unimported ~= nil then
		gopls.completeUnimported = conf.complete_unimported
	end
end

local function lua_ls_on_attach(client, _)
	if client.config.settings.Lua == nil then
		client.config.settings.Lua = {}
	end
	if client.config.settings.Lua.diagnostics == nil then
		client.config.settings.Lua.diagnostics = {}
	end
	for _, var in pairs(LuaEditorconfig.globals) do
		table.insert(client.config.settings.Lua.diagnostics.globals, var)
	end
end

local M = {}

-- Setup all the custom editorconfig properties.
---@param opts table|nil
function M.setup(opts)
	local defaultOpts = {
		gopls = true,
		yamlls = true,
	}
	opts = opts or defaultOpts
	-- set defaults using "keep"
	vim.tbl_extend("keep", opts, defaultOpts)
	-- editorconfig.properties.custom_property = function(bufnr, val, opts) end

	editorconfig.properties.go_build_tags = function(_, val, _)
		add_tags(val)
	end
	editorconfig.properties.go_build_flags = function(_, val, _)
		add_flags(val)
	end
	editorconfig.properties.go_complete_unimported = function(_, val, _)
		GoplsEditorconfig.complete_unimported = to_bool(val)
	end
	for _, name in pairs(gopls_analyses_attrs) do
		editorconfig.properties["go_" .. name] = function(_, val, _)
			GoplsEditorconfig.analyses[name] = to_bool(val)
		end
	end

	editorconfig.properties.lua_globals = function(_, val, _)
		util.extend(LuaEditorconfig.globals, util.split(strip_string(val), ","))
	end

	editorconfig.properties.yaml_schema = function(_, val, _)
		yaml_add_schemas(val)
	end

	for name in pairs(DisabledLSPEditorConfig) do
		editorconfig.properties["lsp_" .. name .. "_disabled"] = function(_, val, _)
			DisabledLSPEditorConfig[name] = to_bool(val)
		end
	end
end

-- lsp_on_attach will use the internal configuration and convert it to lsp settings.
--
---@param client lsp.Client
---@param bufnr number
function M.lsp_on_attach(client, bufnr)
	local name = client.config.name
	if name == "gopls" then
		gopls_on_attach(client, bufnr)
	elseif name == "lua_ls" then
		lua_ls_on_attach(client, bufnr)
	elseif name == "yamlls" then
		--
	end
end

return M
