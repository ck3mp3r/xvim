{vimPlugins, ...}: [
  {
    pkg = vimPlugins.markdown-preview-nvim;
    ft = ["markdown"];
  }
  {
    pkg = vimPlugins.rainbow-delimiters-nvim;
    event = ["BufRead"];
  }
  {
    pkg = vimPlugins.nvim-autopairs;
    config = true;
    event = ["InsertEnter"];
  }
  {
    pkg = vimPlugins.better-escape-nvim;
    opts = {
      mapping = ["jj" "jk"];
      timeout = 150;
    };
    event = ["InsertEnter"];
  }
  {
    pkg = vimPlugins.indent-blankline-nvim;
    main = "ibl";
    opts = {
      indent = {char = "▏";};
      scope = {
        char = "▏";
        show_start = false;
        show_end = false;
      };
    };
    event = ["BufRead"];
  }
  {
    pkg = vimPlugins.surround;
    event = ["InsertEnter"];
  }
]
