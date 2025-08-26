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
      --TODO: remove when https://github.com/LazyVim/LazyVim/pull/6354 is merged
      local module = require("catppuccin.groups.integrations.bufferline")
      if module then
        module.get = module.get_theme
      end
      require("catppuccin").setup(opts)
    end,
  },
}
