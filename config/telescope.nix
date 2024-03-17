{vimPlugins, ...}: let
  keys = import ./util/keys.nix {};
  keyInfo = keys.convert [
    (keys.silent ":Telescope projects <CR>" "<Leader>p" "Projects")
  ];
in
  with vimPlugins; {
    plugin = {
      pkg = telescope-nvim;
      cmd = ["Telescope"];
      dependencies = [
        plenary-nvim
        {
          pkg = project-nvim;
          config = ''
            function()
              require("project_nvim").setup {}
            end
          '';
          event = ["VimEnter"];
        }
        {
          pkg = telescope-fzf-native-nvim;
          config = ''
            function()
              require'telescope'.load_extension('fzf')
            end
          '';
        }
        telescope-project-nvim
      ];
      opts = {
        sync_with_nvim_tree = true;
      };
    };
    registrations = keyInfo.descriptions;
    bindings = keyInfo.bindings;
  }
