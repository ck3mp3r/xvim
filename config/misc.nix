{pkgs, ...}:
with pkgs.vimPlugins; [
  {
    pkg = markdown-preview-nvim;
    ft = ["markdown"];
  }
  {
    pkg = rainbow-delimiters-nvim;
    event = ["BufRead"];
  }
  {
    pkg = nvim-autopairs;
    config = true;
    event = ["InsertEnter"];
  }
  {
    pkg = better-escape-nvim;
    opts = {
      mapping = ["jj" "jk"];
      timeout = 150;
    };
    event = ["InsertEnter"];
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
    event = ["BufRead"];
  }
  {
    pkg = surround;
    event = ["InsertEnter"];
  }
]
