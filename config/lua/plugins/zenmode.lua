return {
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    init = function()
      vim.keymap.set('n', '<leaader>tz', ':ZenMode <CR>',
        { silent = true, desc = '[T]oggle [Z]enMode' })
    end,
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
