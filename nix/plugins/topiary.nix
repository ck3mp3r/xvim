{pkgs, ...}: let
  treeSitterNuSrc = pkgs.fetchFromGitHub {
    owner = "nushell";
    repo = "tree-sitter-nu";
    rev = "2a153c88d5d44d96653057c7cc14292f4e641bef";
    sha256 = "sha256-Mv4XxJSO0bLF/JB6U5WCtu6sXqW6T6tOTKzsbnc/zcs="; # Replace with the actual hash
  };

  topiaryNushellRepo = pkgs.fetchFromGitHub {
    owner = "blindFS";
    repo = "topiary-nushell";
    rev = "main";
    sha256 = "sha256-pxgG2zYWLrxksDIs/nQtnpaITLYhYZ5LktWqiH/Zs1w=";
  };

  treeSitterNu = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-nu";
    src = treeSitterNuSrc;

    buildInputs = [ pkgs.tree-sitter pkgs.nodejs pkgs.gcc ];

    buildPhase = ''
      tree-sitter generate
    '';

    installPhase = ''
      mkdir -p $out/lib
      gcc -shared -o $out/lib/tree_sitter_nu.so src/parser.c src/scanner.c -I./src
    '';
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "topiary-nu";
    src = topiaryNushellRepo;

    buildPhase = ''
      mkdir $out
      cat <<EOF > $out/languages.ncl
      {
        languages = {
          nu = {
            extensions = ["nu"],
            grammar.source.path = "${treeSitterNu}/lib/tree_sitter_nu.so"
          },
        },
      }
      EOF
    '';

    installPhase = ''
      cp -r $src/languages $out
    '';
  }
