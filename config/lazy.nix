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
  noice = import ./noice.nix {inherit pkgs;};
  nonels = import ./none-ls.nix {inherit pkgs;};
  nvimtree = import ./nvim-tree.nix {inherit (pkgs) vimPlugins;};
  telescope = import ./telescope.nix {inherit (pkgs) vimPlugins;};
  toggleterm = import ./toggleterm.nix {inherit pkgs;};
  treesitter = import ./treesitter.nix {inherit pkgs;};
  zenmode = import ./zenmode.nix {inherit pkgs;};

  keys = import ./keys.nix {
    inherit pkgs helpers;
    registrations =
      git.registrations
      // toggleterm.registrations
      // telescope.registrations
      // bufferline.registrations
      // lsp.registrations
      // zenmode.registrations
      // direnv.registrations;
  };

  plugins = with pkgs.vimPlugins; [
    alpha
    bufferline.plugin
    catppuccin
    cmp
    direnv.plugin
    git.plugin
    comment
    keys.plugin
    lsp.plugin
    lualine.plugin
    {
      pkg = markdown-preview-nvim;
      ft = ["markdown"];
    }
    noice
    nonels
    nvim-autopairs
    nvimtree
    rainbow-delimiters-nvim
    surround
    telescope.plugin
    tmux-navigator
    toggleterm.plugin
    treesitter
    vim-bbye
    zenmode.plugin
    {
      pkg = better-escape-nvim;
      opts = {
        mapping = ["jj" "jk"];
        timeout = 150;
      };
    }
    {
      pkg = indent-blankline-nvim;
      main = "ibl";
      opts = {
        indent = {
          char = "▏";
        };
        scope = {
          char = "▏";
          show_start = false;
          show_end = false;
        };
      };
    }
  ];
in {
  config = {
    plugins.lazy = {
      inherit plugins;
      enable = true;
    };
    keymaps = keys.bindings ++ telescope.bindings ++ toggleterm.bindings ++ git.bindings ++ bufferline.bindings ++ lsp.bindings ++ zenmode.bindings ++ direnv.bindings;
  };
}
