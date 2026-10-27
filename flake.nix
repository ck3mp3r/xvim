{
  description = "A nixvim configuration";

  inputs = {
    base-nixpkgs.url = "github:ck3mp3r/flakes?dir=base-nixpkgs";
    nixpkgs.follows = "base-nixpkgs/unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    topiary-nu = {
      url = "github:ck3mp3r/flakes?dir=topiary-nu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-nvim = {
      url = "github:NotAShelf/direnv.nvim";
      flake = false;
    };
    mega-cmdparse = {
      url = "github:ColinKennedy/mega.cmdparse";
      flake = false;
    };
    mega-logging = {
      url = "github:ColinKennedy/mega.logging";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
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
            # avante.nvim 0.4 requires mega.cmdparse, which requires
            # mega.logging. nixpkgs ships both only from recent revisions, so
            # fall back to the pinned upstream sources.
            mega-cmdparse =
              prev.vimPlugins.mega-cmdparse
              or (prev.vimUtils.buildVimPlugin {
                pname = "mega.cmdparse";
                src = inputs.mega-cmdparse;
                version = "custom";
                requiredLuaModules = [prev.neovim-unwrapped.lua.pkgs.mega-logging];
              });
            mega-logging =
              prev.vimPlugins.mega-logging
              or (prev.vimUtils.buildVimPlugin {
                pname = "mega.logging";
                src = inputs.mega-logging;
                version = "custom";
              });
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
        };
      in {
        _module.args.pkgs = pkgs';

        formatter = pkgs'.alejandra;

        packages.default = nvim;

        devShells.default = pkgs'.mkShell {
          packages = ci.packages;
          shellHook = ci.shellHook;
        };
      };
    };
}
