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
    aerial-nvim
    avante-nvim
    better-escape-nvim
    bufdelete-nvim
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
    dressing-nvim
    git-blame-nvim
    gitsigns-nvim
    indent-blankline-nvim
    lsp-format-nvim
    lsp_lines-nvim
    lualine-nvim
    luasnip
    render-markdown-nvim
    markdown-preview-nvim
    mini-icons
    mini-nvim
    neogit
    noice-nvim
    none-ls-nvim
    nui-nvim
    nvim-autopairs
    nvim-cmp
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-lspconfig
    nvim-navic
    nvim-nio
    nvim-notify
    nvim-tree-lua
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-web-devicons
    plenary-nvim
    project-nvim
    rainbow-delimiters-nvim
    rustaceanvim
    surround
    telescope-fzf-native-nvim
    telescope-nvim
    telescope-project-nvim
    telescope-ui-select-nvim
    todo-comments-nvim
    toggleterm-nvim
    twilight-nvim
    vim-helm
    vim-tmux-navigator
    which-key-nvim
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
