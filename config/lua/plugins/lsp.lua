return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      lspconfig.nixd.setup {
        settings = {
          nixd = {
            formatting = {
              command = { "alejandra" },
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
      lspconfig.ansiblels.setup {
        capabilities = capabilities
      }
      lspconfig.bashls.setup {
        capabilities = capabilities
      }
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        cmd = { "vscode-json-languageserver", "--stdio" }
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
    end,
    dependencies = {
      "b0o/SchemaStore.nvim",
      -- {
      --   "lukas-reineke/lsp-format.nvim",
      --   opts = {
      --     ["rust-analyzer"] = {
      --       force = true,
      --       sync = true,
      --     },
      --   },
      -- },
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
      -- {
      --   "maan2003/lsp_lines.nvim",
      --   config = function()
      --     vim.diagnostic.config({
      --       virtual_text = false,
      --       virtual_lines = {
      --         only_current_line = true
      --       }
      --     })
      --     require("lsp_lines").setup()
      --   end
      -- },
      {
        "mrcjkb/rustaceanvim",
        ft = "rust",
        dependencies = {
          "neovim/nvim-lspconfig",
          "mfussenegger/nvim-dap",
        }
      },
    }
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require 'aerial'.setup({
        close_automatic_events = {
          "switch_buffer",
          "unsupported"
        },
        ignore = {
          filetypes = {
            "NvimTree"
          }
        }
      })
      vim.keymap.set("n", "<leader>ta", "<cmd>AerialToggle!<CR>", { silent = true, desc = "[T]oggle [A]erial" })
      vim.keymap.set("n", "<leader>tn", "<cmd>AerialNavToggle<CR>",
        { silent = true, desc = "[T]oggle Aerial [N]avigation" })
    end,
    event = "BufReadPost",
  }
}
