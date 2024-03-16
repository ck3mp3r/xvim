{pkgs, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":ObsidianOpen " "<Leader>oo" "Open Note")
    (keys.silent ":ObsidianNew " "<Leader>on" "New Note")
  ];
in
  with pkgs.vimPlugins; {
    plugin = {
      pkg = obsidian-nvim;
      ft = ["markdown"];
      opts = {
        workspaces = [
          {
            name = "personal";
            path = "~/Documents/Projects/ck3mp3r/obsidian-notes";
          }
        ];
      };
    };

    dependencies = [
      plenary-nvim
    ];

    bindings = keyInfo.bindings;
    registrations = keyInfo.descriptions // {"<leader>o" = "Obsidian";};
  }
