{ pkgs, ... }:
let
  keys = (import ./util/keys.nix { });
  keyInfo = keys.convert [
    (keys.silent ":Telescope projects <CR>" "<Leader>p" "Projects")
  ];
in
{
  config = {

    extraPlugins = with pkgs.vimPlugins; [
      project-nvim
      telescope-project-nvim
    ];

    extraConfigLuaPost = ''
      require("project_nvim").setup {}
    '';

    keymaps = keyInfo.bindings;
    plugins.which-key.registrations = keyInfo.descriptions;
  };
}
