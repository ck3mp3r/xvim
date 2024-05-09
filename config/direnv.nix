{vimPlugins, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":DirenvExport <CR>" "<Leader>dx" "Direnv Export")
    # (keys.silent ":EditDirenvrc <CR>" "<Leader>de" "Edit direnvrc")
  ];
in {
  plugin = {
    pkg = vimPlugins.direnv-vim;
    event = ["VeryLazy"];
  };
  bindings = keyInfo.bindings;
  registrations = keyInfo.descriptions // {"<leader>d" = "Direnv";};
}
