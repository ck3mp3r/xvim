{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    devshell,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [devshell.overlays.default];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {allowUnfree = true;};
        };

        config = pkgs.callPackage ./nix/config.nix {};

        plugins = pkgs.callPackage ./nix/plugins.nix {};

        nvim = pkgs.callPackage ./nix/wrapper.nix {
          appName = "nvim";
          configPath = "${config}";
          runtimePaths =
            [
              pkgs.vimPlugins.lazy-nvim
            ]
            ++ plugins.runtimePaths;
          extraVars = plugins.extraVars;
        };

        individualPackages = with pkgs; {
          inherit
            bash-language-server
            black
            lua
            luarocks
            nodejs
            nvim
            python3
            ruff
            shellcheck
            shfmt
            stylua
            vscode-js-debug
            vtsls
            ;
          inherit (nodePackages) vscode-json-languageserver;
          inherit (python312Packages) pip;
        };
      in {
        formatter = pkgs.alejandra;

        packages =
          individualPackages
          // {
            default = pkgs.buildEnv {
              name = "xvim packages";
              paths = builtins.attrValues individualPackages;
            };
          };

        devShells.default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };
      }
    );
}
