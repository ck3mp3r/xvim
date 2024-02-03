{
  plugins.nvim-tree = {
    enable = true;
    preferStartupRoot = true;
    respectBufCwd = true;
    syncRootWithCwd = true;
    updateFocusedFile = {
      enable = true;
      updateRoot = true;
    };

    modified.enable = true;

    diagnostics.enable = true;

    view = {
      signcolumn = "yes";
    };

    renderer = {
      icons = {
        gitPlacement = "signcolumn";
      };
      rootFolderLabel = {
        __raw = ''
          function(path)
            return vim.fn.fnamemodify(path, ":t")
          end
        '';
      };
    };

    onAttach = {
      __raw = ''
        function(bufnr)
          require("nvimtree").onAttach(bufnr)
        end
      '';
    };
  };
}
