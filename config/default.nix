{pkgs, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":NvimTreeToggle <CR>" "<Leader>e" "Toggle Tree")
  ];
in {
  config = {
    globals.mapleader = " ";

    options = {
      clipboard = "unnamedplus";
      colorcolumn = "120";
      conceallevel = 1;
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
      "lua/xvim-components.lua" = builtins.readFile ./lua/xvim-components.lua;
    };

    extraPackages = with pkgs; [
      lua-language-server
      nil
      nodePackages.vscode-json-languageserver-bin
      yaml-language-server
    ];
  };

  imports = [
    ./autocmd.nix
    ./lazy.nix
  ];
}
