local opts = {
  blink_cmp = true,
  native_lsp = {
    enabled = true,
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
    },
  },
  transparent_background = true,
  treesitter = true,
  treesitter_context = true,
  which_key = true,
}
require("catppuccin").setup(opts)
vim.cmd("colorscheme catppuccin")
