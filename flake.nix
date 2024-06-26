{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
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
        wrapper = pkgs.callPackage ./nix/wrapper.nix {
          appName = "nvim";
          configLocation = "${config}/config";
          runtimePaths =
            [
              pkgs.vimPlugins.lazy-nvim
            ]
            ++ plugins.runtimePaths;
          extraVars = plugins.extraVars;
        };
      in {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };

        packages = {
          default = wrapper;
        };
      }
    );
}
