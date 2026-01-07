-- LazyVim
--
-- https://www.lazyvim.org/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

local export = {}

function export.setup(spec)
  lazy.setup({
    spec = spec,
    defaults = {
      lazy = true,
      version = false, -- always use the latest git commit
      --version = "*", -- try using the latest stable version if semver is supported
    },
    checker = { enabled = false }, -- automatically check for plugin updates
    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false, -- get a notification when changes are found
    },
    dev = {
      path = "~/.config/nvim/dev",
    },
  })
end

return export
