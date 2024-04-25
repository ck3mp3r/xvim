{
  pkgs,
  helpers,
  ...
}: let
  alpha = import ./alpha.nix {inherit (pkgs) vimPlugins;};
  bufferline = import ./bufferline.nix {inherit (pkgs) vimPlugins;};
  catppuccin = import ./catppuccin.nix {inherit (pkgs) vimPlugins;};
  cmp = import ./cmp.nix {inherit (pkgs) vimPlugins;};
  comment = import ./comment.nix {inherit (pkgs) vimPlugins;};
  direnv = import ./direnv.nix {inherit (pkgs) vimPlugins;};
  git = import ./git.nix {inherit (pkgs) vimPlugins;};
  lsp = import ./lsp.nix {
    inherit (pkgs) vimPlugins;
    inherit helpers;
  };
  lualine = import ./lualine.nix {inherit (pkgs) vimPlugins;};
  misc = import ./misc.nix {inherit (pkgs) vimPlugins;};
  noice = import ./noice.nix {inherit (pkgs) vimPlugins;};
  nonels = import ./none-ls.nix {inherit (pkgs) vimPlugins;};
  nvimtree = import ./nvim-tree.nix {inherit (pkgs) vimPlugins;};
  obsidian = import ./obsidian.nix {inherit (pkgs) vimPlugins;};
  telescope = import ./telescope.nix {inherit (pkgs) vimPlugins;};
  toggleterm = import ./toggleterm.nix {inherit (pkgs) vimPlugins;};
  treesitter = import ./treesitter.nix {inherit pkgs;};
  zenmode = import ./zenmode.nix {inherit (pkgs) vimPlugins;};

  keys = import ./keys.nix {
    inherit (pkgs) vimPlugins;
    inherit helpers;
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
