{
  plugins.none-ls = {
    enable = true;
    sources = {

      code_actions = {
        shellcheck.enable = true;
        gitsigns.enable = true;
      };

      diagnostics = {
        shellcheck.enable = true;
      };

      formatting = {
        jq.enable = true;
        rustfmt.enable = true;
        shfmt.enable = true;
      };
    };
  };
}
