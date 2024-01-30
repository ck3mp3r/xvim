let
  keys = (import ./util/keys.nix { });
  keyInfo = keys.convert [
    (keys.silent "<cmd>LspInfo<cr>" "<leader>li" "Info")
    (keys.silent "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>" "<leader>ld" "Buffer Diagnostics")
    (keys.silent "<cmd>Telescope diagnostics<cr>" "<leader>lw" "Diagnostics")
    (keys.silent "<cmd>Telescope lsp_document_symbols<cr>" "<leader>ls" "Document Symbols")
    (keys.silent "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" "<leader>lS" "Workspace Symbols")
    (keys.silent "<cmd>Telescope quickfix<cr>" "<leader>le" "Telescope Quickfix")
    (keys.silent "<cmd>lua vim.diagnostic.goto_next()<cr>" "<leader>lj" "Next Diagnostic")
    (keys.silent "<cmd>lua vim.diagnostic.goto_prev()<cr>" "<leader>lk" "Prev Diagnostic")
    (keys.silent "<cmd>lua vim.diagnostic.setloclist()<cr>" "<leader>lq" "Quickfix")
    (keys.silent "<cmd>lua vim.lsp.buf.code_action()<cr>" "<leader>la" "Code Action")
    (keys.silent "<cmd>lua vim.lsp.buf.format()<cr>" "<leader>lf" "Format")
    (keys.silent "<cmd>lua vim.lsp.buf.rename()<cr>" "<leader>lr" "Rename")
    (keys.silent "<cmd>lua vim.lsp.codelens.run()<cr>" "<leader>ll" "CodeLens Action")
  ];
in
{
  plugins.lsp = {
    enable = true;
    servers = {
      # ansiblels.enable = true;
      bashls.enable = true;
      # dockerls.enable = true;
      gopls = {
        enable = true;
        installLanguageServer = false;
      };
      jsonls.enable = true;
      kotlin-language-server = {
        enable = true;
        installLanguageServer = false;
      };
      lua-ls.enable = true;
      nixd.enable = true;
      pyright = {
        enable = true;
        installLanguageServer = false;
      };
      rust-analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings.files.excludeDirs = [ ".direnv" ];
      };
      terraformls.enable = true;
      yamlls.enable = true;
    };

    keymaps = {
      lspBuf = {
        K = "hover";
        gD = "declaration";
        gd = "definition";
        gr = "references";
        gI = "implementation";
        gs = "signature_help";
      };
    };
  };

  plugins.lsp-format = {
    enable = false;
    setup = {
      rust-analyzer = {
        exclude = [ "rust-analyzer" ];
        force = true;
        sync = true;
      };
    };
  };

  # plugins.lsp-lines = {
  #   enable = true;
  # };

  plugins.cmp-nvim-lsp-document-symbol.enable = true;
  plugins.cmp-nvim-lsp-signature-help.enable = true;

  keymaps = keyInfo.bindings;
  plugins.which-key.registrations = keyInfo.descriptions // { "<leader>l" = "LSP"; };
}
