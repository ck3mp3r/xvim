return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufRead" },
  },
  {
    "direnv/direnv.vim",
    event = { "VeryLazy" },
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
    event = { "InsertEnter" },
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      formatters_by_ft = {
        nu = { "topiary_nu" },
      },
      formatters = {
        topiary_nu = {
          command = "topiary",
          args = { "format", "--language", "nu" },
        },
      },
    },
  },
}
