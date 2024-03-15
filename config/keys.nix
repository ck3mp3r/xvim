{
  pkgs,
  helpers,
  registrations,
  ...
}: let
  keys = import ./util/keys.nix {};

  keyInfo = keys.convert [
    (keys.silent ":w <CR>" "<C-s>" "Save")
    (keys.silent "<cmd>nohlsearch<CR>" "<leader>h" "No Highlight")
    (keys.silent "<cmd>Bdelete<CR>" "<Leader>c" "Close")
    (keys.silent "<cmd>Telescope colorscheme<cr>" "<leader>sc" "Colorscheme")
    (keys.silent "<cmd>Telescope commands<cr>" "<leader>sC" "Commands")
    (keys.silent "<cmd>Telescope find_files<cr>" "<leader>sf" "Find File")
    (keys.silent "<cmd>Telescope git_branches<cr>" "<leader>sb" "Checkout branch")
    (keys.silent "<cmd>Telescope help_tags<cr>" "<leader>sh" "Find Help")
    (keys.silent "<cmd>Telescope highlights<cr>" "<leader>sH" "Find highlight groups")
    (keys.silent "<cmd>Telescope keymaps<cr>" "<leader>sk" "Keymaps")
    (keys.silent "<cmd>Telescope live_grep<cr>" "<leader>st" "Text")
    (keys.silent "<cmd>Telescope man_pages<cr>" "<leader>sM" "Man Pages")
    (keys.silent "<cmd>Telescope oldfiles<cr>" "<leader>sr" "Open Recent File")
    (keys.silent "<cmd>Telescope registers<cr>" "<leader>sR" "Registers")
    (keys.silent "<cmd>Telescope resume<cr>" "<leader>sl" "Resume last search")
  ];

  mappings =
    registrations
    // keyInfo.descriptions
    // {
      "<leader>s" = "Search";
    };
in {
  bindings = keyInfo.bindings;

  plugin = {
    pkg = pkgs.vimPlugins.which-key-nvim;
    # config = true;
    config = ''
      function()
        require("which-key").setup({})
        require("which-key").register(${helpers.toLuaObject mappings})
      end
    '';
    event = "VeryLazy";
  };
}
