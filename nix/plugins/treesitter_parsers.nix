{pkgs, ...}: let
  ts_plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      bash
      cue
      go
      hcl
      helm
      html
      java
      javascript
      jq
      json
      jsonnet
      kotlin
      lua
      make
      markdown
      markdown_inline
      nix
      python
      regex
      rust
      starlark
      typescript
      yaml
    ]);
in
  pkgs.symlinkJoin {
    name = "ts-parsers";
    paths = ts_plugin.dependencies;
  }
