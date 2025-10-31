{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    topiary-nu = {
      url = "github:ck3mp3r/flakes?dir=topiary-nu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codecompanion = {
      url = "github:olimorris/codecompanion.nvim";
      flake = false;
    };
    direnv-nvim = {
      url = "github:NotAShelf/direnv.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        codecompanion' = pkgs.vimUtils.buildVimPlugin {
          pname = "codecompanion.nvim";
          version = "custom";
          src = inputs.codecompanion;
          dependencies = [pkgs.vimPlugins.plenary-nvim];
          nvimSkipModule = [
            "codecompanion.providers.completion.blink.setup"
            "codecompanion.providers.completion.cmp.setup"
            "codecompanion.providers.actions.telescope"
            "codecompanion.providers.actions.fzf_lua"
            "codecompanion.providers.actions.mini_pick"
            "codecompanion.providers.actions.snacks"
            "minimal"
          ];
        };

        direnv-nvim' = pkgs.vimUtils.buildVimPlugin {
          pname = "direnv.nvim";
          src = inputs.direnv-nvim;
          version = "custom";
        };

        overlays = [
          inputs.topiary-nu.overlays.default
          (final: next: {
            codecompanion-nvim = codecompanion';
            direnv-nvim = direnv-nvim';
            mcphub-nvim = inputs.mcphub-nvim.packages."${system}".default;
            mcp-hub = inputs.mcp-hub.packages."${system}".default;
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
      in {
        _module.args.pkgs = pkgs';

        formatter = pkgs'.alejandra;

        packages.default = nvim;

        devenv.shells.default = {
          imports = [./devenv.nix];
        };
      };
    };
}
