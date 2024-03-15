{pkgs, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":ZenMode <CR>" "<Leader>z" "Toggle ZenMode")
  ];
in
  with pkgs.vimPlugins; {
    plugin = {
      pkg = zen-mode-nvim;
      cmd = ["ZenMode"];
      opts = {
        plugins.tmux.enabled = true;
      };
      dependencies = [
        twilight-nvim
      ];
    };

    bindings = keyInfo.bindings;
    registrations = keyInfo.descriptions;
  }
