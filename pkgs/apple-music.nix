{
  fetchurl,
  google-chrome,
  lib,
  makeDesktopItem,
  runtimeShell,
  symlinkJoin,
  writeScriptBin,
  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? [ ],
}:
let
  name = "apple-music-via-google-chrome";

  meta = {
    description = "Open Apple Music in Google Chrome app mode";
    homepage = google-chrome.meta.homepage or null;
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.roberth ];
    platforms = google-chrome.meta.platforms or lib.platforms.all;
  };

  desktopItem = makeDesktopItem {
    inherit name;
    exec = name;
    icon = fetchurl {
      name = "apple-music-icon.png";
      url = "https://music.apple.com/assets/favicon/favicon-180.png";
      sha256 = "sha256-lZXt+kbYCBTLzK1S9QcxVwIhin2x8iNUAcrSHtmWmOY=";
      meta.license = lib.licenses.unfree;
    };
    desktopName = "Apple Music via Google Chrome";
    genericName = "Music streaming service";
    categories = [ "AudioVideo" ];
    startupNotify = true;
  };

  script = writeScriptBin name ''
    #!${runtimeShell}
    exec ${google-chrome}/bin/${google-chrome.meta.mainProgram} ${lib.escapeShellArgs commandLineArgs} \
      --app=https://music.apple.com/browse?l=en_US \
      --no-first-run \
      --no-default-browser-check \
      --no-crash-upload \
      "$@"
  '';
in
symlinkJoin {
  inherit name meta;
  paths = [
    script
    desktopItem
  ];
}
