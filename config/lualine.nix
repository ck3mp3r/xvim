{ vimPlugins, ... }:
let
  winbar_lualine = [
    {
      "__unkeyed" = "filetype";
      colored = true;
      icon_only = true;
    }
    "filename"
    "navic"
  ];

  sections = {
    lualine_a = [{
      "__unkeyed".__raw = ''
        function()
          return require('icons').ui.Target .. " "
        end
      '';
    }];
    lualine_b = [{
      "__unkeyed" = "branch";
      icon = "";
    }];
    lualine_c = [ "" ];
    lualine_x = [
      {
        "__unkeyed".__raw = ''
          require('xvim-components').lsp
        '';
      }
      {
        "__unkeyed".__raw = ''
          require('xvim-components').spaces
        '';
      }
      { "__unkeyed" = "filetype"; }
    ];
    lualine_y = [ ];
    lualine_z = [ ];
  };
in {
  plugin = {
    pkg = vimPlugins.lualine-nvim;
    event = [ "VimEnter" ];
    dependencies = [{
      pkg = vimPlugins.nvim-navic;
      opts = { lsp.auto_attach = true; };
    }];
    opts = {
      options = {
        globalstatus = true;
        section_separators.left = "";
        section_separators.right = "";
        component_separators.left = "";
        component_separators.right = "";
        theme = "catppuccin";
        disabled_filetypes = {
          statusline = [ "alpha" ];
          winbar = [ "NvimTree" "alpha" ];
        };
      };

      sections = sections;
      inactive_sections = sections;

      inactive_winbar = { lualine_c = winbar_lualine; };

      winbar = { lualine_c = winbar_lualine; };
    };
  };
}
