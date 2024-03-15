{pkgs, ...}:
with pkgs.vimPlugins; {
  pkg = comment-nvim;
  config = true;
  keys = ["gc" "gb"];
}
