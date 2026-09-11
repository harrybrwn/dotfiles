local custom = require("core.plugins.filetree")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- nvim-tree: An alternate file explorer
---@type LazyPluginSpec[]
return {
  {
    "nvim-tree/nvim-tree.lua",
    -- dev = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy", "BufEnter" },
    keys = {
      { "g0", vim.cmd.NvimTreeFindFile, mode = "n" },
      {
        "<leader>f",
        vim.cmd.NvimTreeFindFileToggle,
        mode = "n",
        desc = "[F]iletree toggle",
      },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      view = {
        side = "left",
        width = "15%",
        -- width = {
        --   min = 40,
        --   max = "20%",
        -- },
        -- width = { min = "10%", max = 40 },
        -- width = { min = 40, max = "20%" },
        centralize_selection = false,        -- center with 'zz' when entering the tree
        cursorline = true,                   -- show line at the cursor
        preserve_window_proportions = false, -- don't readjust window sizes
        float = {
          enable = false,
          quit_on_focus_loss = true,
        }, -- view in floating window
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      modified = {
        enable = true,
        show_on_open_dirs = false,
      },
      renderer = {
        highlight_modified = "none",     -- none|icon|name|all
        highlight_git = "icon",          -- none|icon|name|all
        highlight_diagnostics = "none",
        highlight_opened_files = "none", -- none|icon|name|all
        group_empty = true,              -- group empty folders as one pathname
        indent_markers = {
          enable = false,
        },
        special_files = {
          "Cargo.toml",
          "Makefile",
          "README.md",
          "readme.md",
          "go.mod",
        },
      },
      tab = { sync = { open = true, close = true } },
      diagnostics = { enable = true },
      update_focused_file = {
        enable = true, -- move cursor to current open file
        update_root = true,
        ignore_list = { "node_modules", ".git" },
      },
      filesystem_watchers = {
        ignore_dirs = { "node_modules", ".git", "build" },
      },
      -- git = {
      --   work_tree = function(path)
      --     local join = vim.fs.joinpath
      --     local home = vim.env.HOME
      --     if path == home then
      --       return home
      --     end
      --     local xdg_config = os.getenv("XDG_CONFIG_HOME") or join(home, ".config")
      --     local profile = join(vim.env.HOME, ".local/profile.d")
      --     local res = nil
      --     if path:sub(1, #xdg_config) == xdg_config or path:sub(1, #profile) == profile then
      --       res = home
      --     end
      --     -- vim.print(string.format("work_tree(%s) -> %s", path, res))
      --     return res
      --   end,
      --   git_dir = function(path)
      --     local join = vim.fs.joinpath
      --     local home = vim.env.HOME
      --     local xdg_config = os.getenv("XDG_CONFIG_HOME") or join(home, ".config")
      --     local profile = join(vim.env.HOME, ".local/profile.d")
      --     local res = nil
      --     if path == home or path:sub(1, #xdg_config) == xdg_config or path:sub(1, #profile) == profile then
      --       res = vim.fs.joinpath(xdg_config, "dots/repo")
      --     end
      --     -- vim.print(string.format("git_dir(%s) -> %s", path, res))
      --     return res
      --   end,
      -- },
      on_attach = custom.on_attach,
    },
  },
}
