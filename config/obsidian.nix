{pkgs, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":ObsidianNew<cr> " "<Leader>on" "New Note")
    (keys.silent ":ObsidianSearch<cr>" "<Leader>os" "Search Notes")
    (keys.silent ":ObsidianTemplate<cr>" "<Leader>ot" "Search Templates")
  ];
in
  with pkgs.vimPlugins; {
    plugin = {
      pkg = obsidian-nvim;
      ft = ["markdown"];
      cmd = ["ObsidianNew" "ObsidianSearch"];
      opts = {
        workspaces = [
          {
            name = "personal";
            path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes";
          }
        ];
        preferred_link_style = "markdown";
        templates = {
          subdir = "templates";
          date_format = "%Y-%m-%d";
          time_format = "%H:%M";
          substitutions = {};
        };
      };
    };

    dependencies = [
      plenary-nvim
    ];

    bindings = keyInfo.bindings;
    registrations = keyInfo.descriptions // {"<leader>o" = "Obsidian";};
  }
