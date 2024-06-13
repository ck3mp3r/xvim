return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
      require 'which-key'.setup({})

      require 'which-key'.register({
        b = { name = '[B]uffer', _ = 'which_key_ignore' },
        c = { name = '[C]ode', _ = 'which_key_ignore' },
        d = { name = '[D]ocument', _ = 'which_key_ignore' },
        e = { ":NvimTreeToggle <CR>", "Toggle Explorer" },
        g = { name = '[G]it', _ = 'which_key_ignore' },
        h = { ":nohlsearch<CR>", "No Highlight" },
        q = { ":qa <CR>", "quit" },
        r = { name = '[R]ename', _ = 'which_key_ignore' },
        s = { name = '[S]earch', _ = 'which_key_ignore' },
        t = { name = '[T]oggle', _ = 'which_key_ignore' },
        w = { name = '[W]orkspace', _ = 'which_key_ignore' },
        x = { ":DirenvExport <CR>", "Direnv Export" },
      }, { prefix = "<leader>" })

      require 'which-key'.register({
        b = {
          c = { ":Bdelete<CR>", "Close" },
          o = { ":BufferLineCloseOthers <CR>", "Close Others" },
          h = { ":BufferLineCloseLeft <CR>", "Close Left" },
          l = { ":BufferLineCloseRight <CR>", "Close Right" },
          e = { ":BufferLinePickClose <CR>", "Pick To Close" },
        },
        t = {
          f = { ":ToggleTerm direction=float<cr>", "[T]ogggle [F]loating terminal" },
          h = { ":ToggleTerm direction=horizontal<cr>", "[T]oggle [H]orizontal terminal" },
          v = { ":ToggleTerm direction=vertical<cr>", "[T]oggle [V]ertical terminal" },
          z = { ":ZenMode <CR>", "[T]oggle [Z]enMode" }
        },
      }, { prefix = "<leader>" })
    end
  }
}
