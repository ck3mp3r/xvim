let
  winbar_lualine = [
    {
      name = "filetype";
      extraConfig = {
        icon_only = true;
      };
    }
    "filename"
    "navic"
  ];

  sections = {
    lualine_a = [
      {
        name = ''
          require('icons').ui.Target .. " "
        '';
      }
    ];
    lualine_b = [
      {
        name = "branch";
        icon = "";
      }
    ];
    lualine_c = [
      {
        name = ''
          ""
        '';
      }
    ];
    lualine_x = [
      {
        name = ''
          require('lualine-components').lsp()
        '';
      }
      {
        name = ''
          require('lualine-components').spaces()
        '';
      }
      {
        name = "filetype";
      }

    ];
    lualine_y = [ ];
    lualine_z = [ ];
  };

in
{
  plugins = {
    navic = {
      enable = true;
      lsp.autoAttach = true;
    };

    lualine = {
      enable = true;
      globalstatus = true;
      sectionSeparators.left = "";
      sectionSeparators.right = "";
      componentSeparators.left = "";
      componentSeparators.right = "";

      disabledFiletypes = {
        statusline = [ "alpha" ];
        winbar = [ "NvimTree" "alpha" ];
      };

      extensions = [
        "navic"
      ];

      sections = sections;
      inactiveSections = sections;

      inactiveWinbar = {
        lualine_c = winbar_lualine;
      };

      winbar = {
        lualine_c = winbar_lualine;
      };
    };
  };
}
