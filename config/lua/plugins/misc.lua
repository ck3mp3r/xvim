return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = { signs = false },
    event = { "BufReadPost" },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufRead" },
  },
  {
    "windwp/nvim-autopairs",
    config = true,
    event = { "InsertEnter" },
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      mapping = { "jj", "jk" },
      timeout = 150,
    },
    event = { "InsertEnter" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏", },
      scope = {
        char = "▏",
        show_start = false,
        show_end = false,
      },
    },
    event = { "BufReadPost" }
  },
  {
    "tpope/vim-surround",
    event = { "InsertEnter" },
  },
}
