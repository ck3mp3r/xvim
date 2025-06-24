{pkgs, ...}: let
  ts_plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      bash
      cue
      go
      graphql
      hcl
      helm
      html
      http
      java
      javascript
      jq
      json
      jsonnet
      just
      kdl
      kotlin
      lua
      make
      markdown
      markdown_inline
      nix
      nu
      python
      regex
      rust
      starlark
      swift
      terraform
      tsx
      typescript
      yaml
    ]);
in
  pkgs.symlinkJoin {
    name = "ts-parsers";
    paths = ts_plugin.dependencies;
  }
