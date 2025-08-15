local ts_parsers = vim.g.ts_parsers
local opts = {
  parser_install_dir = ts_parsers,
  ensure_installed = {},
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
}

vim.opt.runtimepath:append(ts_parsers)
require("nvim-treesitter.configs").setup(opts)
