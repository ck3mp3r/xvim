{
  plugins.alpha = {
    enable = true;

    layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = [
          "██╗     ███████╗████████╗███████╗"
          "██║     ██╔════╝╚══██╔══╝██╔════╝"
          "██║     █████╗     ██║   ███████╗"
          "██║     ██╔══╝     ██║   ╚════██║"
          "███████╗███████╗   ██║   ███████║"
          "╚══════╝╚══════╝   ╚═╝   ╚══════╝"
          "                                 "
          "        ██████╗  ██████╗         "
          "        ██╔══██╗██╔═══██╗        "
          "        ██║  ██║██║   ██║        "
          "        ██║  ██║██║   ██║        "
          "        ██████╔╝╚██████╔╝        "
          "        ╚═════╝  ╚═════╝         "
          "                                 "
          "████████╗██╗  ██╗██╗███████╗██╗  "
          "╚══██╔══╝██║  ██║██║██╔════╝██║  "
          "   ██║   ███████║██║███████╗██║  "
          "   ██║   ██╔══██║██║╚════██║╚═╝  "
          "   ██║   ██║  ██║██║███████║██╗  "
          "   ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  "
        ];
        opts = {
          position = "center";
          hl = "Type";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            shortcut = "f";
            desc = "󰈞  Find file";
            command = "<CMD>:Telescope find_files <CR>";
          }
          {
            shortcut = "n";
            desc = "  New file";
            command = "<CMD>ene <CR>";
          }
          {
            shortcut = "p";
            desc = "  Projects";
            command = "<CMD>:Telescope projects <CR>";
          }
          {
            shortcut = "r";
            desc = "  Recent file";
            command = "<CMD>:Telescope oldfiles <CR>";
          }
          {
            shortcut = "t";
            desc = "󰊄  Find text";
            command = "<CMD>:Telescope live_grep <CR>";
          }
          {
            shortcut = "q";
            desc = "󰅖  Quit Neovim";
            command = ":qa<CR>";
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = "Is it Friday yet?!";
        opts = {
          position = "center";
          hl = "Keyword";
        };
      }
    ];
  };
}
