{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    nixGrammars = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      go
      json
      kotlin
      lua
      markdown
      markdown_inline
      nix
      regex
      rust
      yaml
    ];
  };
}
