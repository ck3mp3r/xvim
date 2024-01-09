{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixvim = { url = "github:nix-community/nixvim/nixos-23.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, nixvim, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./config;
          extraSpecialArgs = {
            keys = (import ./util/keys.nix { });
          };
        };
      in
      {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };
      }
    );
}
