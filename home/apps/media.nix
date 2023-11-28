{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  config = lib.mkIf config.isGraphical {
    programs.imv.enable = isLinux;
    programs.mpv.enable = isLinux;
    programs.zathura.enable = isLinux;

    home.packages = lib.mkIf isLinux [(pkgs.callPackage ../../pkgs/apple-music.nix {})];

    services.discord-applemusic-rich-presence.enable = isDarwin;

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "zathura.desktop";
      "image/gif" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
    };
  };
}
