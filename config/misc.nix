{
  plugins.auto-save = {
    enable = false;
    enableAutoSave = false;
  };

  plugins.better-escape = {
    enable = true;
    mapping = [ "jj" "jk" ];
    timeout = 150;
  };

  plugins.tmux-navigator.enable = true;
  plugins.markdown-preview.enable = true;

  plugins.surround.enable = true;

  # project-nvim.enable = true;

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
        caseMode = "smart_case";
      };
      # project-nvim.enable = true;
    };
  };

  plugins.rainbow-delimiters.enable = true;
  plugins.nvim-autopairs.enable = true;
  # plugins.navic = {
  #   enable = true;
  #   lsp.autoAttach = true;
  # };

  plugins.vim-bbye.enable = true;

  plugins.comment-nvim.enable = true;

  plugins.indent-blankline = {
    enable = true;
    indent = {
      char = "▏";
    };
    scope = {
      char = "▏";
      showStart = false;
      showEnd = false;
    };
  };
}
