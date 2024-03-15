{pkgs, ...}: let
  keys = import ./util/keys.nix {};
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
in {
  plugin = {
    pkg = pkgs.vimPlugins.nvim-lspconfig;
    config = ''
      function()
        local lspconfig = require('lspconfig')
        lspconfig.ansiblels.setup {}
        lspconfig.bashls.setup {}
        lspconfig.jsonls.setup {}
        lspconfig.nil_ls.setup {}
        lspconfig.terraformls.setup {}
        lspconfig.yamlls.setup {}
        lspconfig.rust_analyzer.setup {
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = false
              },
              files = {
                excludeDirs = { ".direnv", ".git", ".github" },
              }
            }
          }
        }
        lspconfig.pyright.setup {}
        lspconfig.gopls.setup {}
        lspconfig.kotlin_language_server.setup {}
        lspconfig.lua_ls.setup {}

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          end,
        })
      end
    '';
    lazy = false;

    dependencies = with pkgs.vimPlugins; [
      {
        pkg = lsp-format-nvim;
        opts = {
          rust-analyzer = {
            force = true;
            sync = true;
          };
        };
      }
      {
        pkg = vim-helm;
        config = ''
          function()
            local lspconfig = require('lspconfig')
            lspconfig.helm_ls.setup {
              settings = {
                ['helm-ls'] = {
                  yamlls = {
                    path = "yaml-language-server",
                  }
                }
              }
            }
          end
        '';
      }
      {
        pkg = lsp_lines-nvim;
        config = ''
          function()
            vim.diagnostic.config({
              virtual_text = false,
              virtual_lines = {
                only_current_line = true
              }
            })
            require("lsp_lines").setup()
          end
        '';
      }
    ];
  };

  # plugins.lsp-lines = {
  #   enable = true;
  # };

  bindings = keyInfo.bindings;
  registrations = keyInfo.descriptions // {"<leader>l" = "LSP";};
}
