{pkgs, ...}: let
  ts_plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      bash
      go
      java
      javascript
      json
      hcl
      kotlin
      lua
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
