return {
  {
    {
      "NeogitOrg/neogit",
      config = true,
      cmd = { "Neogit" },
      dependencies = {
        "sindrets/diffview.nvim"
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      config = true,
      dependencies = {
        {
          "f-person/git-blame.nvim",
          opts = {
            delay = 150,
            enabled = false,
          },
          cmd = { "GitBlameToggle" },
        }
      },
      cmd = { "Gitsigns" },
      event = { "BufReadPost" },
    }
  }
}
