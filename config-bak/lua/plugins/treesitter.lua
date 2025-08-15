local ts_parsers = vim.g.ts_parsers
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
      parser_install_dir = ts_parsers,
      ensure_installed = {},
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(_, opts)
      vim.opt.runtimepath:append(ts_parsers)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
