{pkgs, ...}: let
  mkEntryFromDrv = drv:
    if pkgs.lib.isDerivation drv
    then {
      name = "${pkgs.lib.getName drv}";
      path = drv;
    }
    else drv;

  LazyVimCustom = pkgs.vimPlugins.LazyVim.overrideAttrs (oldAttrs: {
    postInstall = ''
      echo "return {}" > $out/lua/lazyvim/plugins/treesitter.lua
    '';
  });

  vimPlugins = with pkgs.vimPlugins; [
    # LazyVim
    LazyVimCustom
    SchemaStore-nvim
    aerial-nvim
    avante-nvim
    better-escape-nvim
    # bufdelete-nvim
    bufferline-nvim
    catppuccin-nvim
    cmp-buffer
    # cmp-cmdline
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-path
    # cmp_luasnip
    # comment-nvim
    conform-nvim
    # copilot-cmp
    copilot-lua
    # diffview-nvim
    direnv-vim
    dressing-nvim
    friendly-snippets
    flash-nvim
    fzf-lua
    # git-blame-nvim
    gitsigns-nvim
    grug-far-nvim
    indent-blankline-nvim
    # lsp-format-nvim
    # lsp_lines-nvim
    lazydev-nvim
    lualine-nvim
    # luasnip
    render-markdown-nvim
    markdown-preview-nvim
    # mason-nvim
    # mason-lspconfig-nvim
    # mason-nvim-dap-nvim
    mini-ai
    mini-comment
    mini-diff
    mini-icons
    mini-nvim
    mini-move
    mini-pairs
    mini-surround
    neo-tree-nvim
    # neogit
    noice-nvim
    # none-ls-nvim
    # nvim-autopairs
    nvim-cmp
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-lint
    nvim-lspconfig
    nvim-navic
    nvim-nio
    # nvim-notify
    # nvim-tree-lua
    nvim-snippets
    nvim-ts-autotag
    nui-nvim
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-web-devicons
    persistence-nvim
    plenary-nvim
    # project-nvim
    rainbow-delimiters-nvim
    rustaceanvim
    snacks-nvim
    ts-comments-nvim
    trouble-nvim
    # surround
    telescope-fzf-native-nvim
    telescope-nvim
    telescope-project-nvim
    telescope-ui-select-nvim
    todo-comments-nvim
    # toggleterm-nvim
    # twilight-nvim
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
