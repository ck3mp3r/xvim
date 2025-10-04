require("lazy").setup({
  spec = {
    { import = "plugins" },
    { "folke/tokyonight.nvim", enabled = false },
    { "jay-babu/mason-nvim-dap.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "mason-org/mason.nvim", enabled = false },
  },
  dev = {
    path = vim.g.plugin_path,
    patterns = { "" },
    fallback = false,
  },
  install = {
    missing = false,
  },
  checker = {
    enabled = false, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
