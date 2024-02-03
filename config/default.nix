let
  keys = (import ./util/keys.nix { });
  keyInfo = keys.convert [
    (keys.silent ":NvimTreeToggle <CR>" "<Leader>e" "Toggle Tree")
  ];
in
{
  config = {
    globals.mapleader = " ";

    colorschemes.catppuccin = {
      enable = true;
      transparentBackground = true;
    };

    options = {
      clipboard = "unnamedplus";
      colorcolumn = "120";
      cursorcolumn = false;
      expandtab = true;
      ignorecase = true;
      number = true;
      pumheight = 10;
      relativenumber = true;
      shiftwidth = 2;
      showtabline = 2;
      signcolumn = "yes";
      smartindent = true;
      swapfile = false;
      tabstop = 2;
      undofile = true;
    };

    keymaps = keyInfo.bindings;
    plugins.which-key.registrations = keyInfo.descriptions;

    extraFiles = {
      "lua/icons.lua" = builtins.readFile ./lua/icons.lua;
      "lua/lazygit.lua" = builtins.readFile ./lua/lazygit.lua;
      "lua/lualine-components.lua" = builtins.readFile ./lua/lualine-components.lua;
      "lua/nvimtree.lua" = builtins.readFile ./lua/nvimtree.lua;
    };
  };

  # Import all your configuration modules here
  imports = [
    ./alpha.nix
    ./autocmd.nix
    ./bufferline.nix
    ./cmp.nix
    ./git.nix
    ./helm.nix
    ./keys.nix
    ./lsp.nix
    ./lualine.nix
    ./misc.nix
    ./noice.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./project.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./zenmode.nix
  ];
}
