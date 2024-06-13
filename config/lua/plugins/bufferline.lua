return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            highlight = "PanelHeading",
            padding = 1,
          }
        }
      }
    },
    config = function(_, opts)
      require 'bufferline'.setup(opts)
      vim.keymap.set('n', 'H', ':BufferLineCyclePrev <CR>', { desc = 'Previous Buffer' })
      vim.keymap.set('n', 'L', ':BufferLineCycleNext <CR>', { desc = 'Next Buffer' })
    end,
    event = { "BufReadPost" }
  }
}
