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
        inputs.git-hooks.flakeModule
      ];

      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        config,
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

        opencode-nvim' = pkgs.vimUtils.buildVimPlugin {
          pname = "opencode.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "NickvanDyke";
            repo = "opencode.nvim";
            rev = "main";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
          version = "custom";
        };

        overlays = [
          inputs.topiary-nu.overlays.default
          (final: next: {
            codecompanion-nvim = codecompanion';
            direnv-nvim = direnv-nvim';
            mcphub-nvim = inputs.mcphub-nvim.packages."${system}".default;
            mcp-hub = inputs.mcp-hub.packages."${system}".default;
            opencode-nvim = next.vimPlugins.opencode-nvim.overrideAttrs (oldAttrs: {
              runtimeDeps = [next.curl];
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
