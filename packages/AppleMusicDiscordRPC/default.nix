{
  fetchzip,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "AppleMusicDiscordRPC";
  version = "1.3.0";

  src = fetchzip {
    url = "https://github.com/jkelol111/AppleMusicDiscordRPC/releases/download/${version}/AppleMusicDiscordRPC-${version}.zip";
    sha256 = "sha256-uB257AGO7lf9FXMb4Qd02fCl507sIZjuNU0MSnZGJMw=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/Applications"
    ls -l $src
    cp -r "Apple Music Discord RPC.app" "$out/Applications/Apple Music Discord RPC.app"
  '';

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    maintainers = [maintainers.nekowinston];
    platforms = platforms.darwin;
  };
}
