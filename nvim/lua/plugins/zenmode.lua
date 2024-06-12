return {
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = {
      plugins = {
        tmux = {
          enabled = true
        }
      },
      dependencies = {
        "folke/twilight.nvim"
      }
    }
  }
}
