{ pkgs, ... }:
let
  keys = (import ./util/keys.nix { });
  keyInfo = keys.convert [
    (keys.silent ":ZenMode <CR>" "<Leader>z" "Toggle ZenMode")
  ];
in
{
  config = {

    extraPlugins = with pkgs.vimPlugins; [
      zen-mode-nvim
      twilight-nvim
    ];

    extraConfigLuaPost = ''
      require('zen-mode').setup({
          plugins = {
            tmux = {
              enabled = true
            }
          }
        }
      )
    '';

    keymaps = keyInfo.bindings;
    plugins.which-key.registrations = keyInfo.descriptions;
  };
}
