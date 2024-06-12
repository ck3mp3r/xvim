{stdenv}:
stdenv.mkDerivation {
  name = "nvim-config";

  src = ../nvim;

  installPhase = ''
    mkdir -p $out/config
    cp -r $src/* $out/config/
  '';
}
