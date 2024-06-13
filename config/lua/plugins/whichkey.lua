return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
      require 'which-key'.setup({})
      require 'which-key'.register({
        e = { ":NvimTreeToggle <CR>", "Toggle Explorer" },
        h = { ":nohlsearch<CR>", "No Highlight" },
        q = { ":qa <CR>", "quit" },
        s = {
          name = "[s]earch",
        },
        g = {
          name = "[g]it",
          C = { ":Telescope git_bcommits<cr>", "Checkout commit (for current file)" },
          R = { ":lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          b = { ":Telescope git_branches<cr>", "Checkout branch" },
          c = { ":Telescope git_commits<cr>", "Checkout commit" },
          d = { ":Gitsigns diffthis HEAD<cr>", "Git Diff" },
          g = { ":lua require 'xvim-components'.toggle()<cr>", "Lazygit" },
          j = { ":lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
          k = { ":lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
          l = { ":lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          n = { ":Neogit<cr>", "Open Neogit" },
          o = { ":Telescope git_status<cr>", "Open changed file" },
          p = { ":lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { ":lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          s = { ":lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          t = { ":GitBlameToggle<cr>", "Toggle Git Blame" },
          u = { ":lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
        },
        l = {
          name = "[l]sp",
          _ = 'which_key_ignore'
        },
        b = {
          name = "[b]uffer",
          c = { ":Bdelete<CR>", "Close" },
          o = { ":BufferLineCloseOthers <CR>", "Close Others" },
          h = { ":BufferLineCloseLeft <CR>", "Close Left" },
          l = { ":BufferLineCloseRight <CR>", "Close Right" },
          e = { ":BufferLinePickClose <CR>", "Pick To Close" },
        },
        d = { ":DirenvExport <CR>", "Direnv Export" },
        t = {
          name = "Toggle Term",
          f = { ":ToggleTerm direction=float<cr>", "Floating terminal" },
          h = { ":ToggleTerm direction=horizontal<cr>", "Horizontal terminal" },
          v = { ":ToggleTerm direction=vertical<cr>", "Vertical terminal" },
        },
        z = { ":ZenMode <CR>", "Toggle ZenMode" }
      }, { prefix = "<leader>" })
    end
  }
}
