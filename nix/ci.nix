{
  pkgs,
  config,
}: let
  checks-script = pkgs.writeShellScriptBin "checks" ''
    #!/bin/bash

    set -e

    # Filter out terminal escape sequences
    filter_escapes() {
      ${pkgs.gnused}/bin/sed 's/\x1b[^m]*m//g; s/\x1b[[][^a-zA-Z]*[a-zA-Z]//g; s/\x1bP[^\x1b]*\x1b\\//g'
    }

    echo "🔍 Running Neovim diagnostics..."

    echo "Testing configuration..."
    startup_log=$(nix run .# -- --headless -V1 +quit 2>&1 | filter_escapes)

    if echo "$startup_log" | grep -qi "error\|failed\|cannot load\|could not load\|cannot find"; then
        echo "❌ Configuration errors:"
        echo "$startup_log" | grep -i -A2 -B1 "error\|failed\|cannot load\|could not load\|cannot find"
        exit 1
    fi

    echo "Running health check..."
    health_log=$(nix run .# -- --headless +checkhealth +quit 2>&1 | filter_escapes)
    echo "$health_log"

    if echo "$health_log" | grep -qi "error\|failed"; then
        echo "❌ Health check failed"
        exit 1
    fi

    echo "✅ All checks passed!"
  '';

  push-cachix-script = pkgs.writeShellScriptBin "push-cachix" ''
    exec ${pkgs.nushell}/bin/nu ./scripts/push-uncached-to-cachix.nu "$@"
  '';

  packages = with pkgs; [
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
in {
  inherit packages checks-script push-cachix-script;

  pre-commit-hooks = {
    alejandra = {
      enable = true;
      stages = ["pre-push"];
    };
    stylua = {
      enable = true;
      stages = ["pre-push"];
    };
  };

  shellHook = ''
    ${config.pre-commit.installationScript}
  '';
}
