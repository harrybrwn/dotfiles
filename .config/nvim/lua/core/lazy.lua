-- LazyVim
--
-- https://www.lazyvim.org/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.api.nvim_echo({ { "Failed to import \"lazy\"", "ErrorMsg" } }, true, {})
  return
end

local M = {}

function M.setup(spec)
  lazy.setup({
    spec = spec,
    defaults = {
      lazy = true,
      version = false, -- always use the latest git commit
      --version = "*", -- try using the latest stable version if semver is supported
    },
    -- install = {
    --   colorscheme = "gruvbox",
    -- },
    checker = { enabled = false }, -- automatically check for plugin updates
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false, -- get a notification when changes are found
    },
    dev = {
      path = "~/.config/nvim/dev",
    },
    profiling = {
      loader = false,
      require = false,
    },
    performance = {
      cache = {
        enabled = true,
        -- disable_events = {},
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
          "vimballPlugin",
        },
      },
    },
  })
end

return M
