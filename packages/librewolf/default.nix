{ stdenv, fetchurl, lib, undmg }:

stdenv.mkDerivation rec {
  name = "librewolf";
  version = "109.0-1";

  url = "e0b46cbfb55504d33fd75b328ef3f5c7";
  
  src = fetchurl {
    url = "https://gitlab.com/librewolf-community/browser/macos/uploads/${url}/librewolf-${version}.en-US.mac.aarch64.dmg";
    sha256 = "5a60bc2b2d6fc6cbdfae8797178695b7139a0006869e5dbe214078a4d058f1f0";
  };

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Librewolf.app "$out/Applications/Librewolf.app"
  '';

  meta = with lib; {
    description = "A custom version of Firefox, focused on privacy, security and freedom.";
    homepage = "https://librewolf.net/";
    maintainers = [ maintainers.nekowinston ];
    platforms = platforms.darwin;
  };
}
