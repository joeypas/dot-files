-- Install and load better-escape.vim with Neovim's built-in package support.
-- Requires Neovim version with vim.pack support.

local repo = "https://github.com/nvim-zh/better-escape.vim"
local name = "better-escape"

-- Add the plugin package if it isn't already present.
-- Neovim will clone it into its package directory on first use.
vim.pack.add({
  {
    src = repo,
    name = name,
  },
})

-- Configure the plugin after it is loaded.
-- The plugin's global settings are typically set before the plugin is sourced.
vim.g.better_escape_shortcut = "jj"
vim.g.better_escape_interval = 200

-- Load the plugin if needed. For packages in `start`, Neovim loads them automatically
-- on startup; this is just a safe fallback for manual loading setups.
-- pcall(vim.cmd.packadd, name)

