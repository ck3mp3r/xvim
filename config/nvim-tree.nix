let
  func_body = builtins.readFile ./lua/nvim-tree.lua;
in
{
  plugins.nvim-tree = {
    enable = true;
    updateFocusedFile.enable = true;

    modified.enable = true;

    diagnostics.enable = true;

    view = {
      signcolumn = "yes";
    };

    renderer = {
      icons = {
        gitPlacement = "signcolumn";
      };
    };

    onAttach = {
      __raw = ''
        function(bufnr)
          ${func_body}
        end
      '';
    };
  };
}
