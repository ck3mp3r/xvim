{pkgs, ...}: let
  mkEntryFromDrv = drv:
    if pkgs.lib.isDerivation drv
    then {
      name = "${pkgs.lib.getName drv}";
      path = drv;
    }
    else drv;

  vimPlugins = with pkgs.vimPlugins; [
    SchemaStore-nvim
    alpha-nvim
    better-escape-nvim
    bufferline-nvim
    catppuccin-nvim
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-path
    cmp_luasnip
    comment-nvim
    copilot-cmp
    copilot-lua
    diffview-nvim
    direnv-vim
    git-blame-nvim
    gitsigns-nvim
    indent-blankline-nvim
    lsp-format-nvim
    lsp_lines-nvim
    lspkind-nvim
    lualine-nvim
    luasnip
    markdown-preview-nvim
    neogit
    noice-nvim
    none-ls-nvim
    nui-nvim
    nvim-autopairs
    nvim-cmp
    nvim-lspconfig
    nvim-navic
    nvim-notify
    nvim-tree-lua
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-web-devicons
    plenary-nvim
    project-nvim
    rainbow-delimiters-nvim
    surround
    telescope-fzf-native-nvim
    telescope-nvim
    telescope-project-nvim
    telescope-ui-select-nvim
    toggleterm-nvim
    twilight-nvim
    vim-helm
    vim-tmux-navigator
    which-key-nvim
    zen-mode-nvim
  ];

  ts_parsers = pkgs.callPackage ./plugins/treesitter_parsers.nix {};
  plugins = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv vimPlugins);

  runtimePaths = [
    plugins
  ];

  extraVars = {
    "ts_parsers" = ts_parsers;
    "lazy_path" = plugins;
  };
in {
  inherit plugins runtimePaths extraVars;
}
