local function init()
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  local ts_conds = require("nvim-autopairs.ts-conds")
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")

  -- press % => %% only while inside a comment or string
  npairs.add_rules({
    -- Rule('```', '```', 'markdown'):only_cr(),
    Rule("then", "end", "lua")
        :with_pair(ts_conds.is_not_ts_node({ "string", "comment" }))
        :end_wise(function(opts)
          -- Add any context checks here, e.g. line starts with "if"
          return string.match(opts.line, "^%s*if") ~= nil
        end),
  })
end

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  enabled = true,
  config = function(_, _)
    local opts = {
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "scheme",
        "lisp",
        "text",
        "markdown",
      },
      enable_check_bracket_line = false,
      check_ts = true,
      ts_config = {
        -- go = { 'string', 'comment' },
        -- lua = { 'string', 'comment' },
        ["*"] = { "string" }, -- don't pair when in these tree-sitter nodes
        basic = false,        -- don't check tree-sitter for basic
      },
    }
    require('nvim-autopairs').setup(opts)
    init()
  end,
}
