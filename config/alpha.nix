{pkgs, ...}: let
  asButton = {
    shortcut,
    desc,
    command,
  }: {
    type = "button";
    val = desc;
    on_press.__raw = ''
      function()
        local key = vim.api.nvim_replace_termcodes("${shortcut}", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
      end
    '';
    opts = {
      position = "center";
      shortcut = shortcut;
      cursor = 3;
      width = 50;
      align_shortcut = "right";
      hl_shortcut = "Keyword";
      keymap = [
        "n"
        "${shortcut}"
        "${command}"
        {
          noremap = true;
          silent = true;
          nowait = true;
        }
      ];
    };
  };
in
  with pkgs.vimPlugins; {
    pkg = alpha-nvim;
    opts = {
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
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
            (asButton {
              shortcut = "f";
              desc = "󰈞  Find file";
              command = ":Telescope find_files<CR>";
            })
            (asButton {
              shortcut = "n";
              desc = "  New file";
              command = ":ene<CR>";
            })
            (asButton {
              shortcut = "p";
              desc = "  Projects";
              command = ":Telescope projects<CR>";
            })
            (asButton {
              shortcut = "r";
              desc = "  Recent file";
              command = ":Telescope oldfiles<CR>";
            })
            (asButton {
              shortcut = "t";
              desc = "󰊄  Find text";
              command = ":Telescope live_grep<CR>";
            })
            (asButton {
              shortcut = "q";
              desc = "󰅖  Quit Neovim";
              command = ":qa<CR>";
            })
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
