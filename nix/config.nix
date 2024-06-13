{stdenv}:
stdenv.mkDerivation {
  name = "nvim-config";

  src = ../config;

  installPhase = ''
    mkdir -p $out/config
    cp -r $src/* $out/config/
  '';
}
