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
        lib,
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

        checks-script = pkgs'.writeShellScriptBin "checks" ''
          set -e

          echo "Running Neovim diagnostics..."

          echo "Testing configuration..."
          startup_log=$(nix run .# -- --headless -V1 +quit 2>&1)

          if echo "$startup_log" | grep -qi "error\|failed\|cannot load\|could not load\|cannot find"; then
              echo "Configuration errors:"
              echo "$startup_log" | grep -i -A2 -B1 "error\|failed\|cannot load\|could not load\|cannot find"
              exit 1
          fi

          echo "Running health check..."
          health_log=$(nix run .# -- --headless +checkhealth +quit 2>&1)
          echo "$health_log"

          if echo "$health_log" | grep -qi "error\|failed"; then
              echo "Health check failed"
              exit 1
          fi

          echo "All checks passed!"
        '';

        push-cachix-script = pkgs'.writeShellScriptBin "push-cachix" ''
          exec ${pkgs'.nushell}/bin/nu ./scripts/push-uncached-to-cachix.nu "$@"
        '';
      in {
        _module.args.pkgs = pkgs';

        formatter = pkgs'.alejandra;

        packages.default = nvim;

        pre-commit.settings.hooks = {
          alejandra = {
            enable = true;
            stages = ["pre-push"];
          };
          stylua = {
            enable = true;
            stages = ["pre-push"];
          };
        };

        devShells.default = pkgs'.mkShell {
          packages = with pkgs'; [
            alejandra
            cachix
            lua-language-server
            nixd
            nodePackages_latest.bash-language-server
            nushell
            pre-commit
            stylua
            checks-script
            push-cachix-script
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
