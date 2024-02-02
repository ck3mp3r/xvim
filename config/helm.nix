{ pkgs, ... }:
{

  config.extraPlugins = [
    {
      plugin = pkgs.vimPlugins.vim-helm;
    }
  ];

  config.extraPackages = with pkgs; [
    helm-ls
  ];

  config.extraConfigLuaPost = ''
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
}
