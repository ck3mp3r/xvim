{
  pkgs,
  helpers,
  ...
}: let
  alpha = import ./alpha.nix {inherit pkgs;};
  bufferline = import ./bufferline.nix {inherit pkgs;};
  catppuccin = import ./catppuccin.nix {inherit pkgs;};
  cmp = import ./cmp.nix {inherit pkgs;};
  comment = import ./comment.nix {inherit pkgs;};
  direnv = import ./direnv.nix {inherit pkgs;};
  git = import ./git.nix {inherit pkgs;};
  lsp = import ./lsp.nix {inherit pkgs helpers;};
  lualine = import ./lualine.nix {inherit pkgs;};
  misc = import ./misc.nix {inherit pkgs;};
  noice = import ./noice.nix {inherit pkgs;};
  nonels = import ./none-ls.nix {inherit pkgs;};
  nvimtree = import ./nvim-tree.nix {inherit (pkgs) vimPlugins;};
  obsidian = import ./obsidian.nix {inherit pkgs;};
  telescope = import ./telescope.nix {inherit (pkgs) vimPlugins;};
  toggleterm = import ./toggleterm.nix {inherit pkgs;};
  treesitter = import ./treesitter.nix {inherit pkgs;};
  zenmode = import ./zenmode.nix {inherit pkgs;};

  keys = import ./keys.nix {
    inherit pkgs helpers;
    registrations =
      git.registrations
      // bufferline.registrations
      // direnv.registrations
      // lsp.registrations
      // obsidian.registrations
      // telescope.registrations
      // toggleterm.registrations
      // zenmode.registrations;
  };

  plugins = with pkgs.vimPlugins;
    [
      alpha
      bufferline.plugin
      catppuccin
      cmp
      comment
      direnv.plugin
      keys.plugin
      lsp.plugin
      lualine.plugin
      noice
      nonels
      nvimtree
      obsidian.plugin
      telescope.plugin
      tmux-navigator
      toggleterm.plugin
      treesitter
      vim-bbye
      zenmode.plugin
    ]
    ++ git.plugins
    ++ misc;
in {
  config = {
    plugins.lazy = {
      inherit plugins;
      enable = true;
    };
    keymaps =
      keys.bindings
      ++ bufferline.bindings
      ++ direnv.bindings
      ++ git.bindings
      ++ lsp.bindings
      ++ obsidian.bindings
      ++ telescope.bindings
      ++ toggleterm.bindings
      ++ zenmode.bindings;
  };
}
