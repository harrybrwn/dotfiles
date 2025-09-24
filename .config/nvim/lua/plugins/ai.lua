local nvm = require("core.util.nvm")
local path = require("core.util.path")

return {
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    keys = {
      -- { "<C-a><C-i>",  function() vim.cmd("CodeCompanionAction") end },
      { "<leader><C-a>", function() vim.cmd("CodeCompanionAction") end },
    },
    init = function()
      require("core.plugins.codecompanion.spinner"):init()
      require("core.plugins.codecompanion.lualine"):init()
    end,
    config = function()
      local adapter = "deepseek_r1"
      require("codecompanion").setup {
        strategies = {
          chat = {
            adapter = adapter,
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
          inline = {
            adapter = adapter,
            keymaps = {
              accept_change = {
                modes = { n = "<S-Tab>" },
                description = "Accept the suggested change",
              },
            }
          },
        },

        adapters = {
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
        },

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
      } -- opts
    end,
  },

  {
    "yetone/avante.nvim",
    enabled = false,
    lazy = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional deps
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      provider = "deepseek",
      vendors = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "llama3.1:8b-instruct-q4_K_M",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
        },
      },
    }
  },

  -- Github Copilot
  {
    "zbirenbaum/copilot.lua",
    -- enabled = function()
    --   local name = vim.fn.hostname()
    --   return name == "jcadmin-Latitude-9520" and os.getenv("USER") == "hbrown"
    -- end,
    enabled = function()
      -- local disabled = require("core.plugins.custom-editorconfig").lsp_disabled.copilot
      -- return not disabled
      -- return vim.fn.executable("/usr/local/bin/nvidia-smi") == 1

      return false
    end,
    lazy = false,
    cmd = "Copilot",
    init = function()
      -- ollama-copilot must be running
      -- see lua/core/plugins/lsp.lua
      vim.g.copilot_proxy = "https://127.0.0.1:11435"
      vim.g.copilot_proxy_strict_ssl = false
    end,
    opts = function()
      local nvm_dir = nvm.dir()
      local version = nvm.default(nvm_dir)
      return {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<S-Tab>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        copilot_node_command = path.join(nvm_dir, "versions/node", version, "bin/node"),
        filetypes = {
          help = false,
        },
      }
    end,
  },

  {
    "github/copilot.vim",
    enabled = false,
    lazy = false,
  }
}
