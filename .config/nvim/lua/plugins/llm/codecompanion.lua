return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
  },
  lazy = true,
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  keys = {
    -- { "<C-a><C-i>",  function() vim.cmd("CodeCompanionAction") end },
    { "<leader><C-a>", function() vim.cmd("CodeCompanionAction") end },
  },

  init = function()
    require("core.plugins.codecompanion.spinner"):init()
    require("core.plugins.codecompanion.lualine"):init()
  end,
  config = function(_, opts)
    local adapter = "anthropic"
    opts.strategies.chat.adapter = adapter
    opts.strategies.inline.adapter = adapter
    require("codecompanion").setup(opts)
  end,

  opts = {
    ignore_warnings = true,
    strategies = {
      inline = {
        adapter = nil, -- replace this later
        keymaps = {
          accept_change = {
            modes = { n = "<S-Tab>" },
            description = "Accept the suggested change",
          },
        }
      },
      chat = {
        adapter = {
          name = "anthropic",
          model = "claude-sonnet-4-6",
        }, -- replace this later
        keymaps = {
          close = {
            modes = { n = "<C-q>", i = "<C-q>" },
          },
        },
        slash_commands = {
          ["file"] = {
            -- Location to the slash command in CodeCompanion
            callback = "strategies.chat.slash_commands.file",
            description = "Select a file using Telescope",
            opts = {
              provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
              contains_code = true,
            },
          },
        },
        ["buffer"] = {
          opts = {
            provider = "snacks",
            keymaps = {
              modes = {
                i = "<C-b>",
              },
            },
          },
        },
      },
    }, -- strategies

    interactions = {
      chat = {
        adapters = "claude_code",
        roles = {
          user = "NvMegaChad Companion",
        },
      },
      inline = {
        adapter = {
          name = "anthropic",
          model = "claude-sonnet-4-6",
        },
      },
    },

    adapters = {
      -- TODO: npm install -g @zed-industries/claude-code-acp
      http = {
        deepseek_r1 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "deepseek-r1",
            schema = {
              model = {
                -- default = "deepseek-r1:8b-llama-distill-q4_K_M",
                default = "deepseek-r1:7b-qwen-distill-q4_K_M",
              },
              num_ctx = {
                default = 131072,
              },
              num_predict = {
                default = -1,
              },
            }
          })
        end,
        llama3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                -- default = "llama3:latest",
                -- default = "llama3.2:3b-instruct-q4_K_M",
                -- default = "llama3.1:8b-instruct-q4_K_M",
                -- default = "llama3.1:8b-instruct-q6_K"
                default = "deepseek-r1:7b-qwen-distill-q4_K_M",
              },
              num_ctx = {
                default = 131072,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },
    }, -- adapters

    display = {
      action_palette = {
        provider = "telescope",               -- default|telescope|mini_pick
        opts = {
          show_default_actions = true,        -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
      chat = {
        ---Customize how tokens are displayed
        ---@param tokens number
        ---@param adapter CodeCompanion.Adapter
        ---@return string
        token_count = function(tokens, adapter)
          return string.format(" [%d tokens (%s)]", tokens, adapter.name)
        end,
      }
    },

    opts = {
      log_level = 'DEBUG',
      allow_insecure = true,
    },
  }, -- opts
}
