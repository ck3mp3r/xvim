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
      relativenumber = true;
      shiftwidth = 2;
      showtabline = 2;
      signcolumn = "yes";
      smartindent = true;
      tabstop = 2;
    };

    keymaps = keyInfo.bindings;
    plugins.which-key.registrations = keyInfo.descriptions;
  };

  # Import all your configuration modules here
  imports = [
    ./alpha.nix
    ./bufferline.nix
    ./cmp.nix
    ./git.nix
    ./keys.nix
    ./lsp.nix
    ./lualine.nix
    ./misc.nix
    ./noice.nix
    ./none-ls.nix
    ./nvim-tree.nix
    ./toggleterm.nix
    ./treesitter.nix
  ];
}
