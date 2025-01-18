{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  config = lib.mkIf config.isGraphical {
    programs.imv.enable = isLinux;
    programs.mpv.enable = isLinux;
    programs.zathura.enable = true;

    home.packages = lib.mkIf isLinux [ pkgs.supersonic-wayland ];

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
