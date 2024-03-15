{pkgs, ...}: let
  keys = import ./util/keys.nix {};

  keyInfo = keys.convert [
    (keys.silent "<cmd>ToggleTerm direction=float<cr>" "<leader>tf" "Floating terminal")
    (keys.silent "<cmd>ToggleTerm direction=horizontal<cr>" "<leader>th" "Horizontal terminal")
    (keys.silent "<cmd>ToggleTerm direction=vertical<cr>" "<leader>tv" "Vertical terminal")
  ];
in {
  plugin = with pkgs.vimPlugins; {
    pkg = toggleterm-nvim;
    opts = {
      float_opts.border = "curved";
    };
    cmd = [
      "ToggleTerm"
      "TermExec"
      "ToggleTermToggleAll"
      "ToggleTermSendCurrentLine"
      "ToggleTermSendVisualLines"
      "ToggleTermSendVisualSelection"
    ];
  };

  bindings = keyInfo.bindings;
  registrations =
    keyInfo.descriptions
    // {
      "<leader>t" = "Terminal";
    };
}
