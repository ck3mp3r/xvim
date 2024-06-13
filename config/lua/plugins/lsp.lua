return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('xvim-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<leader>ld', ":Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics")
          map('<leader>le', ":Telescope quickfix<cr>", "Telescope Quickfix")
          map('<leader>lf', ":lua vim.lsp.buf.format({timeout_ms=5000})<cr>", "Format")
          map('<leader>li', ":LspInfo<cr>", "Info")
          map('<leader>lj', ":lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic")
          map('<leader>lk', ":lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic")
          map('<leader>ll', ":lua vim.lsp.codelens.run()<cr>", "CodeLens Action")
          map('<leader>lq', ":lua vim.diagnostic.setloclist()<cr>", "Quickfix")
          map('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>lw', ":Telescope diagnostics<cr>", "Diagnostics")
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('xvim-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('xvim-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'xvim-lsp-highlight', buffer = event2.buf }
              end,
            })

            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end, '[T]oggle Inlay [H]ints')
            end
          end
        end
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
