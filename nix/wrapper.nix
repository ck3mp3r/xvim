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

  topiary_nu = pkgs.callPackage ./plugins/topiary.nix {};
  extraPackages = with pkgs; [
    alejandra
    black
    cue
    dockerfile-language-server-nodejs
    lldb
    lua-language-server
    marksman
    nixd
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.vscode-json-languageserver
    pyright
    shellcheck
    shfmt
    vscode-extensions.vadimcn.vscode-lldb.adapter
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
      export TOPIARY_CONFIG_FILE=${topiary_nu}/languages.ncl
      export TOPIARY_LANGUAGE_DIR=${topiary_nu}/languages
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
