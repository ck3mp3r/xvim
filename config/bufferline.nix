{vimPlugins, ...}: let
  keys = import ./util/keys.nix {};

  keyInfo = keys.convert [
    (keys.silent ":BufferLineCycleNext <CR>" "L" "Next")
    (keys.silent ":BufferLineCyclePrev <CR>" "H" "Previous")
    (keys.silent "<cmd>Bdelete<CR>" "<Leader>bc" "Close")
    (keys.silent ":BufferLineCloseOthers <CR>" "<Leader>bo" "Close Others")
    (keys.silent ":BufferLineCloseLeft <CR>" "<Leader>bh" "Close Left")
    (keys.silent ":BufferLineCloseRight <CR>" "<Leader>bl" "Close Right")
    (keys.silent ":BufferLinePickClose <CR>" "<Leader>be" "Pick To Close")
  ];
in {
  plugin = {
    pkg = vimPlugins.bufferline-nvim;
    opts = {
      options = {
        offsets = [
          {
            filetype = "NvimTree";
            text = "Explorer";
            highlight = "PanelHeading";
            padding = 1;
          }
        ];
      };
    };
    event = ["BufReadPost"];
  };
  bindings = keyInfo.bindings;
  registrations = keyInfo.descriptions // {"<leader>b" = "Buffers";};
}
