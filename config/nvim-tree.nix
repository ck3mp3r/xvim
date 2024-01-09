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
