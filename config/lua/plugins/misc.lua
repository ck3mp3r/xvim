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
}
