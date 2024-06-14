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
      init = function()
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { silent = true, desc = 'Git: ' .. desc })
        end

        map('<leader>gC', ":Telescope git_bcommits<cr>", "Checkout commit (for current file)")
        map('<leader>gR', ":lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer")
        map('<leader>gb', ":Telescope git_branches<cr>", "Checkout branch")
        map('<leader>gc', ":Telescope git_commits<cr>", "Checkout commit")
        map('<leader>gd', ":Gitsigns diffthis HEAD<cr>", "Git Diff")
        map('<leader>gg', ":lua require 'xvim-components'.toggle()<cr>", "Lazygit")
        map('<leader>gj', ":lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk")
        map('<leader>gk', ":lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk")
        map('<leader>gl', ":lua require 'gitsigns'.blame_line()<cr>", "Blame")
        map('<leader>gn', ":Neogit<cr>", "Open Neogit")
        map('<leader>go', ":Telescope git_status<cr>", "Open changed file")
        map('<leader>gp', ":lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk")
        map('<leader>gr', ":lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk")
        map('<leader>gs', ":lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk")
        map('<leader>gu', ":lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk")
        map('<leader>tb', ":GitBlameToggle<cr>", "[T]oggle Git [B]lame")
      end,
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
