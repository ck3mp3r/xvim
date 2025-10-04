return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin-nvim",
    opts = {
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
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
}
