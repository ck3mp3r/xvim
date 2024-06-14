return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      float_opts = {
        border = "curved" }
    },
    init = function()
      vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<cr>',
        { silent = true, desc = '[T]ogggle [F]loating terminal' })
      vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<cr>',
        { silent = true, desc = '[T]oggle [H]orizontal terminal' })
      vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<cr>',
        { silent = true, desc = '[T]oggle [V]ertical terminal' })
    end,
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    }
  }
}
