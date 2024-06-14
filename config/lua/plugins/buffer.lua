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
      vim.keymap.set('n', '<leader>bH', ':BufferLineCyclePrev <CR>', { silent = true, desc = 'Previous Buffer' })
      vim.keymap.set('n', '<leader>bL', ':BufferLineCycleNext <CR>', { silent = true, desc = 'Next Buffer' })
      vim.keymap.set('n', '<leader>bc', ':Bdelete<CR>', { silent = true, desc = 'Close' })
      vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers <CR>', { silent = true, desc = 'Close Others' })
      vim.keymap.set('n', '<leader>bh', ':BufferLineCloseLeft <CR>', { silent = true, desc = 'Close Left' })
      vim.keymap.set('n', '<leader>bl', ':BufferLineCloseRight <CR>', { silent = true, desc = 'Close Right' })
      vim.keymap.set('n', '<leader>be', ':BufferLinePickClose <CR>', { silent = true, desc = 'Pick To Close' })
    end,
    event = { "BufReadPost" }
  },
  {
    "famiu/bufdelete.nvim",
    event = { "BufReadPost" }
  }
}
