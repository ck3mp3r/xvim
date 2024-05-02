{ vimPlugins, ... }:
let
  keys = import ./util/keys.nix { };
  keyInfo = keys.convert [
    (keys.silent ":ObsidianNew<cr> " "<Leader>on" "New Note")
    (keys.silent ":ObsidianSearch<cr>" "<Leader>os" "Search Notes")
    (keys.silent ":ObsidianTemplate<cr>" "<Leader>ot" "Search Templates")
  ];
in {
  plugin = {
    pkg = vimPlugins.obsidian-nvim;
    cmd = [ "ObsidianNew" "ObsidianSearch" ];
    event.__raw = ''
      {
        "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes/**.md",
      }
    '';
    opts = {
      workspaces = [{
        name = "personal";
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes";
      }];
      preferred_link_style = "markdown";
      templates = {
        subdir = "templates";
        date_format = "%Y-%m-%d";
        time_format = "%H:%M";
        substitutions = { };
      };
    };
  };

  dependencies = [ vimPlugins.plenary-nvim ];

  bindings = keyInfo.bindings;
  registrations = keyInfo.descriptions // { "<leader>o" = "Obsidian"; };
}
