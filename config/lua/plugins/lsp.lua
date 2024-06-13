return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require('lspconfig')
      lspconfig.ansiblels.setup {
        capabilities = capabilities
      }
      lspconfig.bashls.setup {
        capabilities = capabilities
      }
      lspconfig.jsonls.setup {
        capabilities = capabilities
      }
      lspconfig.nixd.setup {
        settings = {
          nixd = {
            formatting = {
              command = { "alejandra" },
            }
          }
        }
      }
      lspconfig.terraformls.setup {
        capabilities = capabilities
      }
      lspconfig.tsserver.setup {
        capabilities = capabilities,
      }
      lspconfig.yamlls.setup {
        capabilities = capabilities,
        on_attach = function(client, _)
          if client.name == "yamlls" then
            client.server_capabilities.documentFormattingProvider = true
          end
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            format = {
              enable = true
            },
            validate = true,
            schemaStore = {
              enable = false,
              url = ""
            },
            schemas = require('schemastore').yaml.schemas(),
          }
        }
      }
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true
            },
            diagnostics = {
              enable = false
            },
            files = {
              excludeDirs = { ".direnv", ".git", ".github" },
            }
          }
        }
      }
      lspconfig.pyright.setup {
        capabilities = capabilities
      }
      lspconfig.gopls.setup {
        capabilities = capabilities
      }
      lspconfig.kotlin_language_server.setup {
        capabilities = capabilities
      }
      lspconfig.lua_ls.setup {
        capabilities = capabilities
      }

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
    end,
    dependencies = {
      "b0o/SchemaStore.nvim",
      {
        "lukas-reineke/lsp-format.nvim",
        opts = {
          ["rust-analyzer"] = {
            force = true,
            sync = true,
          },
        },
      },
      {
        "towolf/vim-helm",
        config = function()
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
      },
      {
        "maan2003/lsp_lines.nvim",
        config = function()
          vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = {
              only_current_line = true
            }
          })
          require("lsp_lines").setup()
        end
      }

    }
  }
}
