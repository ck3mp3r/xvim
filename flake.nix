{
  description = "A nixvim configuration";

  inputs = {
    base-nixpkgs.url = "github:ck3mp3r/flakes?dir=base-nixpkgs";
    nixpkgs.follows = "base-nixpkgs/unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    topiary-nu = {
      url = "github:ck3mp3r/flakes?dir=topiary-nu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-nvim = {
      url = "github:NotAShelf/direnv.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        config,
        system,
        ...
      }: let
        overlays = [
          inputs.topiary-nu.overlays.default
          (final: prev: {
            direnv-nvim = prev.vimUtils.buildVimPlugin {
              pname = "direnv.nvim";
              src = inputs.direnv-nvim;
              version = "custom";
            };
            opencode-nvim = prev.vimPlugins.opencode-nvim.overrideAttrs (oldAttrs: {
              runtimeDeps = [prev.curl];
            });
          })
        ];

        pkgs' = import inputs.nixpkgs {
          inherit system overlays;
          config = {allowUnfree = true;};
        };

        nvimConfig = pkgs'.callPackage ./nix/config.nix {};

        plugins = pkgs'.callPackage ./nix/plugins.nix {};

        nvim = pkgs'.callPackage ./nix/wrapper.nix {
          appName = "nvim";
          configPath = "${nvimConfig}";
          runtimePaths = [
            pkgs'.vimPlugins.lazy-nvim
          ];
          extraVars = plugins.extraVars;
        };

        ci = import ./nix/ci.nix {
          pkgs = pkgs';
          inherit config;
        };
      in {
        _module.args.pkgs = pkgs';

        formatter = pkgs'.alejandra;

        packages.default = nvim;

        pre-commit.settings.hooks = ci.pre-commit-hooks;

        devShells.default = pkgs'.mkShell {
          packages = ci.packages;
          shellHook = ci.shellHook;
        };
      };
    };
}
