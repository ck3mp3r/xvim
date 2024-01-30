{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    nixGrammars = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      go
      java
      javascript
      json
      kotlin
      lua
      markdown
      markdown_inline
      nix
      python
      regex
      rust
      starlark
      yaml
    ];
  };
}
