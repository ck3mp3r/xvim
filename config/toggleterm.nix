let
  keys = (import ./util/keys.nix { });

  keyInfo = keys.convert [
    (keys.silent "<cmd>ToggleTerm direction=float<cr>" "<leader>tf" "Floating terminal")
    (keys.silent "<cmd>ToggleTerm direction=horizontal<cr>" "<leader>th" "Horizontal terminal")
    (keys.silent "<cmd>ToggleTerm direction=vertical<cr>" "<leader>tv" "Vertical terminal")
  ];
in
{
  keymaps = keyInfo.bindings;
  plugins.toggleterm = {
    enable = true;
  };

  plugins.which-key.registrations = keyInfo.descriptions // {
    "<leader>t" = "Terminal";
  };
}
