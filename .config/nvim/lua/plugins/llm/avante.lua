local render_markdown_types = {
  "Avante",
  -- "markdown",
}

local plugin = {
  "yetone/avante.nvim",
  enabled = false,
  lazy = false,
  build = "make",
  opts = {
    provider = "claude",

    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-6",
        timeout = 30000, -- Timeout in milliseconds
      },
    },

    -- provider = "deepseek",
    -- vendors = {
    --   ollama = {
    --     __inherited_from = "openai",
    --     api_key_name = "",
    --     endpoint = "http://127.0.0.1:11434/v1",
    --     model = "llama3.1:8b-instruct-q4_K_M",
    --   },
    --   deepseek = {
    --     __inherited_from = "openai",
    --     api_key_name = "DEEPSEEK_API_KEY",
    --     endpoint = "https://api.deepseek.com",
    --     model = "deepseek-coder",
    --   },
    -- },
  },

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
    "nvim-tree/nvim-web-devicons",
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = render_markdown_types,
      },
      ft = render_markdown_types,
    },
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}

return plugin
