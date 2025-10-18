return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {},
        bashls = {},
        cue = {
          cmd = { "cue", "lsp" },
          filetypes = { "cue" },
          root_dir = require("lspconfig.util").root_pattern(".git"),
        },
        jsonls = {
          cmd = { "vscode-json-languageserver", "--stdio" },
        },
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = { ".devenv" },
              },
            },
          },
        },
        sourcekit = {
          cmd = {
            "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
          },
          filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
          root_dir = require("lspconfig.util").root_pattern("Package.swift", ".git"),
        },
        yamlls = {
          cmd = { "yaml-language-server", "--stdio" },
        },
      },
    },
  },
}
