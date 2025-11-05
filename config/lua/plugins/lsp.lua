return {
  -- LSP Configuration - extend LazyVim's default
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Register justls server since it's not built into lspconfig
      local configs = require("lspconfig.configs")
      if not configs.justls then
        configs.just = {
          default_config = {
            cmd = { "just-lsp" },
            filetypes = { "just" },
            root_dir = require("lspconfig.util").root_pattern("justfile", "Justfile", ".git"),
            single_file_support = true,
          },
          docs = {
            description = "Language server for justfiles",
          },
        }
      end

      -- Extend servers configuration
      opts.servers = opts.servers or {}
      opts.servers.just = {}
      opts.servers.ansiblels = {}
      opts.servers.bashls = {}
      opts.servers.cue = {
        cmd = { "cue", "lsp" },
        filetypes = { "cue" },
        root_dir = require("lspconfig.util").root_pattern(".git"),
      }
      opts.servers.jsonls = {
        cmd = { "vscode-json-languageserver", "--stdio" },
      }
      opts.servers.nixd = {
        settings = {
          nixd = {
            formatting = {
              command = { "alejandra" },
            },
          },
        },
      }
      opts.servers.sourcekit = {
        cmd = {
          "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
        },
        filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
        root_dir = require("lspconfig.util").root_pattern("Package.swift", ".git"),
      }
      opts.servers.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
      }

      return opts
    end,
  },
}
