return {
  {
    -- Auto-complete HTML Tags
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    enabled = true,
    lazy = false,
    -- event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = {
        ["html"] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        }
      }
    },
    ft = {
      "astro",
      "svelte",
      "vue",
      "glimmer",
      "handlebars",
      "liquid",
      "markdown",
      "php",
      "rescript",
      "twig",
      "jsx",
      "tsx",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "xml",
      "html",
    },
  },
}
