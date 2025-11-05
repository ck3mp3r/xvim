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
    gopls
    hadolint
    helm-ls
    just
    just-lsp
    jq
    jsonnet-language-server
    kubernetes-helm
    lldb
    lua
    lua-language-server
    marksman
    nixd
    nodePackages.prettier
    nodePackages.vscode-json-languageserver
    pyright
    python3
    python312Packages.pip
    ruff
    rust-analyzer
    shellcheck
    shfmt
    sourcekit-lsp
    stylua
    swift-format
    taplo
    terraform-ls
    tflint
    topiary
    vscode-extensions.vadimcn.vscode-lldb.adapter
    yaml-language-server
  ];

  extraPath = pkgs.lib.makeBinPath extraPackages;
in
  stdenvNoCC.mkDerivation {
    name = appName;
    src = ./.;

    buildInputs = [pkgs.neovim] ++ extraPackages;
    dontUnpack = true;
    dontBuild = true;

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
    '';

    shellHook = ''
      export PATH=${extraPath}:$PATH
    '';
  }
