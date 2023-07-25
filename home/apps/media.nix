{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  applemusic = rec {
    name = "apple-music-via-chrome";
    script = pkgs.writeShellScriptBin name ''
      exec ${pkgs.google-chrome}/bin/${pkgs.google-chrome.meta.mainProgram} \
        --app=https://music.apple.com \
        --no-crash-upload \
        --no-default-browser-check \
        --no-first-run \
        "$@"
    '';
    desktopItem = pkgs.makeDesktopItem {
      inherit name;
      exec = name;
      icon = pkgs.fetchurl {
        name = "Apple Music-icon-2016.png";
        url = "https://assets.nflxext.com/us/ffe/siteui/common/icons/nficon2016.png";
        sha256 = "sha256-c0H3uLCuPA2krqVZ78MfC1PZ253SkWZP3PfWGP2V7Yo=";
        meta.license = lib.licenses.unfree;
      };
      desktopName = "Apple Music via Google Chrome";
      startupNotify = true;
    };
    pkg = pkgs.symlinkJoin {
      inherit name;
      paths = [script desktopItem];
    };
  };
in {
  programs.mpv.enable = isLinux;
  programs.zathura.enable = isLinux;
  home.packages = lib.mkIf isLinux [applemusic.pkg];

  services.discord-applemusic-rich-presence.enable = isDarwin;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zathura.desktop";
    "video/mp4" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
  };
}
