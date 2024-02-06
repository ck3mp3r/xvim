{ pkgs, ... }:
let
  keys = (import ./util/keys.nix { });
  keyInfo = keys.convert [
    (keys.silent ":DirenvExport <CR>" "<Leader>dx" "Direnv Export")
    # (keys.silent ":EditDirenvrc <CR>" "<Leader>de" "Edit direnvrc")
  ];
in
{
  config = {

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = direnv-vim;
        config = "g:direnv_auto 0";
      }
    ];

    keymaps = keyInfo.bindings;
    plugins.which-key.registrations = keyInfo.descriptions // { "<leader>d" = "Direnv"; };
  };
}
