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
  runtimePathCommands = lib.concatStringsSep " " (
    map (path: "--cmd \"set runtimepath^=${path}\"") (
      runtimePaths ++ [configPath]
    )
  );

  topiary-nu = pkgs.topiary-nu;
  extraPackages = with pkgs; [
    alejandra
    bash-language-server
    black
    cue
    dockerfile-language-server-nodejs
    hadolint
    helm-ls
    kubernetes-helm
    lldb
    lua
    lua-language-server
    # marksman
    nixd
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.vscode-json-languageserver
    nodejs
    pyright
    python3
    python312Packages.pip
    ruff
    shellcheck
    shfmt
    shfmt
    sourcekit-lsp
    swift-format
    stylua
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
