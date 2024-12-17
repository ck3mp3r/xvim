{stdenvNoCC}:
stdenvNoCC.mkDerivation {
  name = "nvim-config";

  src = ../config;

  installPhase = ''
    mkdir -p $out
    cp -r $src/lua $out/
    cp -r $src/init.lua $out/
  '';
}
