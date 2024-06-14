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
        g = { name = '[G]it', _ = 'which_key_ignore' },
        h = { ":nohlsearch<CR>", "No [H]ighlight" },
        q = { ":qa <CR>", "[Q]uit" },
        r = { name = '[R]ename', _ = 'which_key_ignore' },
        s = { name = '[S]earch', _ = 'which_key_ignore' },
        t = { name = '[T]oggle', _ = 'which_key_ignore' },
        w = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }, { prefix = "<leader>" })
    end
  }
}
