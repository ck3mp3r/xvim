{pkgs, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent "<cmd>lua require 'xvim-components'.toggle()<cr>" "<leader>gg" "Lazygit")
    (keys.silent "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>" "<leader>gj" "Next Hunk")
    (keys.silent "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>" "<leader>gk" "Prev Hunk")
    (keys.silent "<cmd>lua require 'gitsigns'.blame_line()<cr>" "<leader>gl" "Blame")
    (keys.silent "<cmd>lua require 'gitsigns'.preview_hunk()<cr>" "<leader>gp" "Preview Hunk")
    (keys.silent "<cmd>lua require 'gitsigns'.reset_hunk()<cr>" "<leader>gr" "Reset Hunk")
    (keys.silent "<cmd>lua require 'gitsigns'.reset_buffer()<cr>" "<leader>gR" "Reset Buffer")
    (keys.silent "<cmd>lua require 'gitsigns'.stage_hunk()<cr>" "<leader>gs" "Stage Hunk")
    (keys.silent "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>" "<leader>gu" "Undo Stage Hunk")
    (keys.silent "<cmd>Neogit<cr>" "<leader>gn" "Open Neogit")
    (keys.silent "<cmd>Telescope git_status<cr>" "<leader>go" "Open changed file")
    (keys.silent "<cmd>Telescope git_branches<cr>" "<leader>gb" "Checkout branch")
    (keys.silent "<cmd>Telescope git_commits<cr>" "<leader>gc" "Checkout commit")
    (keys.silent "<cmd>Telescope git_bcommits<cr>" "<leader>gC" "Checkout commit (for current file)")
    (keys.silent "<cmd>Gitsigns diffthis HEAD<cr>" "<leader>gd" "Git Diff")
  ];
in {
  plugins = with pkgs.vimPlugins; [
      {
        pkg = neogit;
        config = true;
        cmd = ["Neogit"];
      }
    {
    pkg = gitsigns-nvim;
    config = true;
    dependencies = [
      {
        pkg = git-blame-nvim;
        opts = {
          delay = 150;
        };
      }
    ];
    cmd = ["Gitsigns"];
    event = ["BufReadPost"];
    }
  ];
  registrations = keyInfo.descriptions // {"<leader>g" = "Git";};
  bindings = keyInfo.bindings;
}
