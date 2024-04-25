{vimPlugins, ...}:
with vimPlugins; {
  pkg = comment-nvim;
  config = true;
  keys = ["gc" "gb"];
}
