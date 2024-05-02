{ vimPlugins, ... }:
let
  keys = import ./util/keys.nix { };
  keyInfo = keys.convert
    [ (keys.silent ":Telescope projects <CR>" "<Leader>p" "Projects") ];
in {
  plugin = {
    pkg = vimPlugins.telescope-nvim;
    cmd = [ "Telescope" ];
    dependencies = [
      vimPlugins.plenary-nvim
      {
        pkg = vimPlugins.project-nvim;
        config = ''
          function()
            require("project_nvim").setup {}
          end
        '';
        event = [ "VimEnter" ];
      }
      {
        pkg = vimPlugins.telescope-fzf-native-nvim;
        config = ''
          function()
            require'telescope'.load_extension('fzf')
          end
        '';
      }
      vimPlugins.telescope-project-nvim
    ];
    opts = { sync_with_nvim_tree = true; };
  };
  registrations = keyInfo.descriptions;
  bindings = keyInfo.bindings;
}
