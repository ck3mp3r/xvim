{pkgs, ...}: {
  containers = {};

  packages = with pkgs; [
    alejandra
    lua-language-server
    nixd
    nodePackages_latest.bash-language-server
    pre-commit
    stylua
  ];

  scripts.checks.exec = ''
    #!/bin/bash

    set -e

    echo "🔍 Running Neovim diagnostics..."

    echo "Testing configuration..."
    startup_log=$(nix run .# -- --headless -V1 +quit 2>&1)

    if echo "$startup_log" | grep -qi "error\|failed\|cannot load\|could not load\|cannot find"; then
        echo "❌ Configuration errors:"
        echo "$startup_log" | grep -i -A2 -B1 "error\|failed\|cannot load\|could not load\|cannot find"
        exit 1
    fi

    echo "Running health check..."
    health_log=$(nix run .# -- --headless +checkhealth +quit 2>&1)
    echo "$health_log"

    if echo "$health_log" | grep -qi "error\|failed"; then
        echo "❌ Health check failed"
        exit 1
    fi

    echo "✅ All checks passed!"
  '';

  git-hooks.hooks = {
    alejandra.enable = true;
    alejandra.stages = ["pre-push"];
    stylua.enable = true;
    stylua.stages = ["pre-push"];
  };
}
