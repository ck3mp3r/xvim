{vimPlugins, ...}: {
  pkg = vimPlugins.comment-nvim;
  config = true;
  keys = ["gc" "gb"];
}
