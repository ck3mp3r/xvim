{
  pkgs,
  stdenvNoCC,
  lib,
  neovim,
  configPath,
  appName,
  extraVars ? {},
  runtimePaths ? [],
}: let
  # Generate the variable commands string in Nix
  extraVarsList =
    lib.attrsets.mapAttrsToList (
      name: value: "--cmd \"let g:${name}='${value}'\""
    ) (
      extraVars // {"config_path" = configPath;}
    );
  varCommands = lib.concatStringsSep " " extraVarsList;

  # Generate the runtime path commands string in Nix
  runtimePathCommands = "--cmd \"set runtimepath=\" --cmd \"set runtimepath^=${lib.concatStringsSep "," ([configPath "${neovim}/share/nvim/runtime"] ++ runtimePaths)}\"";

  topiary-nu = pkgs.topiary-nu;
  extraPackages = with pkgs; [
    alejandra
    bash-language-server
    black
    cue
    dockerfile-language-server
    hadolint
    helm-ls
    jq # For reliable JSON parsing in the wrapper script
    kubernetes-helm
    lldb
    lua
    lua-language-server
    nixd
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.vscode-json-languageserver
    nodejs_24
    pyright
    python3
    python312Packages.pip
    ruff
    shellcheck
    shfmt
    sourcekit-lsp
    stylua
    swift-format
    terraform-ls
    tflint
    topiary
    vscode-extensions.vadimcn.vscode-lldb.adapter
    vscode-js-debug
    vtsls
    yaml-language-server
  ];

  extraPath = pkgs.lib.makeBinPath extraPackages;
in
  stdenvNoCC.mkDerivation {
    name = appName;
    src = ./.;

    buildInputs = [pkgs.neovim] ++ extraPackages;

    installPhase = ''
      mkdir -p $out/bin

      cat > $out/bin/${appName} <<EOF
      #!/usr/bin/env bash

      # Set up Claude OAuth token
      CLAUDE_TOKEN=\$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
      if [[ -n "\$CLAUDE_TOKEN" ]]; then
        export CLAUDE_CODE_OAUTH_TOKEN="\$CLAUDE_TOKEN"
      else
        echo "✗ Claude OAuth token not found in keychain"
      fi

      export TOPIARY_CONFIG_FILE=${topiary-nu}/languages.ncl
      export TOPIARY_LANGUAGE_DIR=${topiary-nu}/languages
      export PATH=${extraPath}:\$PATH
      exec ${neovim}/bin/nvim \
        ${varCommands} \
        ${runtimePathCommands} \
        -u "${configPath}/init.lua" "\$@"
      EOF

      chmod +x $out/bin/${appName}

      # CI extraction script with all paths baked in
      cat > $out/bin/ci-extract.sh <<'EXTRACT_EOF'
      #!/usr/bin/env bash
      set -euo pipefail
      
      BUILD_DIR="''${1:-./build/xvim-dist}"
      echo "Extracting XVIM to $BUILD_DIR..."
      
      # Remove with force to handle read-only files from Nix store
      chmod -R +w "$BUILD_DIR" 2>/dev/null || true
      rm -rf "$BUILD_DIR"
      mkdir -p "$BUILD_DIR"/{bin,config,plugins,parsers,tools}
      
      # Copy config
      echo "Copying config..."
      cp -r ${configPath}/* "$BUILD_DIR/config/"
      
      # Copy neovim binary
      echo "Copying neovim..."
      cp ${neovim}/bin/nvim "$BUILD_DIR/tools/"
      
      # Copy treesitter parsers
      echo "Copying parsers..."
      cp -r ${extraVars.ts_parsers}/* "$BUILD_DIR/parsers/"
      
      # Copy MCP hub
      echo "Copying MCP hub..."
      cp ${extraVars.mcp_cli} "$BUILD_DIR/tools/"
      
      # Copy plugins from link farm
      echo "Copying plugins..."
      PLUGIN_FARM="${extraVars.plugin_path}"
      for plugin_link in "$PLUGIN_FARM"/*; do
          plugin_name=$(basename "$plugin_link")
          plugin_target=$(readlink "$plugin_link")
          echo "  $plugin_name -> $plugin_target"
          cp -r "$plugin_target" "$BUILD_DIR/plugins/$plugin_name"
      done
      
      # Generate portable wrapper with relative paths
      cat > "$BUILD_DIR/bin/xvim" << 'WRAPPER_EOF'
      #!/usr/bin/env bash
      SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"
      XVIM_ROOT="$(dirname "$SCRIPT_DIR")"
      
      export PATH="$XVIM_ROOT/tools:$PATH"
      
      exec "$XVIM_ROOT/tools/nvim" \
        --cmd "let g:config_path='$XVIM_ROOT/config'" \
        --cmd "let g:mcp_cli='$XVIM_ROOT/tools/mcp-hub'" \
        --cmd "let g:plugin_path='$XVIM_ROOT/plugins'" \
        --cmd "let g:ts_parsers='$XVIM_ROOT/parsers'" \
        --cmd "set runtimepath=" \
        --cmd "set runtimepath^=$XVIM_ROOT/config,$XVIM_ROOT/plugins" \
        -u "$XVIM_ROOT/config/init.lua" "$@"
      WRAPPER_EOF
      
      chmod +x "$BUILD_DIR/bin/xvim"
      
      # Create tarball
      echo "Creating distribution archive..."
      cd "$(dirname "$BUILD_DIR")"
      DIST_NAME="xvim-$(date +%Y%m%d)"
      mv "$(basename "$BUILD_DIR")" "$DIST_NAME"
      tar czf "$DIST_NAME.tar.gz" "$DIST_NAME/"
      mv "$DIST_NAME" "$(basename "$BUILD_DIR")"
      
      echo "Distribution built: $(dirname "$BUILD_DIR")/$DIST_NAME.tar.gz"
      echo "Size: $(du -h $(dirname "$BUILD_DIR")/$DIST_NAME.tar.gz | cut -f1)"
      EXTRACT_EOF

      chmod +x $out/bin/ci-extract.sh
    '';

    shellHook = ''
      export PATH=${extraPath}:$PATH
    '';
  }
