{ pkgs, ... }:
{

  config = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-helm
    ];

    extraPackages = with pkgs; [
      helm-ls
    ];

    extraConfigLuaPost = ''
      local lspconfig = require('lspconfig')

      lspconfig.helm_ls.setup {
        settings = {
          ['helm-ls'] = {
            yamlls = {
              path = "yaml-language-server",
            }
          }
        }
      }
    '';
  };
}
