require 'core.options'

require("lazy").setup({
  defaults = {
    lazy = true,
  },
  dev = {
    path = vim.g.lazy_path,
    patterns = { "." },
    fallback = false,
  },
  install = {
    missing = false
  },
  spec = {
    require "plugins.alpha",
    require "plugins.buffer",
    require "plugins.cmp",
    require "plugins.code.dap",
    require "plugins.code.lsp",
    require "plugins.code.treesitter",
    require "plugins.colorscheme",
    require "plugins.comment",
    require "plugins.direnv",
    require "plugins.git",
    require "plugins.lualine",
    require "plugins.markdown",
    require "plugins.misc",
    require "plugins.noice",
    require "plugins.none-ls",
    require "plugins.nvim-tree",
    require "plugins.telescope",
    require "plugins.toggle-term",
    require "plugins.whichkey",
  },
})
