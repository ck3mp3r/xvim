{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
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
  };

  outputs = {
    codecompanion,
    devshell,
    nixpkgs,
    topiary-nu,
    flake-utils,
    mcphub-nvim,
    mcp-hub,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        codecompanion' = pkgs.vimUtils.buildVimPlugin {
          pname = "codecompanion.nvim";
          version = "custom";
          src = codecompanion;
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

        overlays = [
          devshell.overlays.default
          topiary-nu.overlays.default
          (final: next: {
            codecompanion-nvim = codecompanion';
            mcphub-nvim = mcphub-nvim.packages."${system}".default;
            mcp-hub = mcp-hub.packages."${system}".default;
          })
        ];

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
      in {
        formatter = pkgs.alejandra;
        packages.default = nvim;

        devShells.default = pkgs.devshell.mkShell {
          imports = [
            "${devshell}/extra/git/hooks.nix"
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };
      }
    );
}
