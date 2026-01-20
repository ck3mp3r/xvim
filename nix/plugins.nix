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

  codecompanion-nvim = pkgs.codecompanion-nvim;
  direnv-nvim = pkgs.direnv-nvim;
  mcphub-nvim = pkgs.mcphub-nvim;
  opencode-nvim = pkgs.opencode-nvim;

  vimPlugins = with pkgs.vimPlugins; [
    LazyVimCustom
    SchemaStore-nvim
    (aerial-nvim.overrideAttrs {doCheck = false;})
    better-escape-nvim
    blink-cmp
    bufferline-nvim
    catppuccin-nvim
    codecompanion-nvim
    conform-nvim
    copilot-lua
    crates-nvim
    direnv-nvim
    dressing-nvim
    flash-nvim
    friendly-snippets
    fzf-lua
    gitsigns-nvim
    grug-far-nvim
    indent-blankline-nvim
    kulala-nvim
    lazydev-nvim
    lualine-nvim
    opencode-nvim
    render-markdown-nvim
    markdown-preview-nvim
    mcphub-nvim
    mini-ai
    mini-comment
    mini-diff
    mini-icons
    mini-nvim
    mini-move
    mini-pairs
    mini-pick
    mini-surround
    neo-tree-nvim
    noice-nvim
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-lint
    nvim-lspconfig
    nvim-navic
    nvim-nio
    nvim-snippets
    nvim-ts-autotag
    nui-nvim
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-web-devicons
    persistence-nvim
    (obsidian-nvim.overrideAttrs {doCheck = false;})
    plenary-nvim
    rainbow-delimiters-nvim
    rustaceanvim
    snacks-nvim
    ts-comments-nvim
    trouble-nvim
    todo-comments-nvim
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
    "mcp_cli" = "${pkgs.mcp-hub}/bin/mcp-hub";
    "ts_parsers" = ts_parsers;
    "plugin_path" = plugins;
  };
in {
  inherit plugins runtimePaths extraVars;
}
