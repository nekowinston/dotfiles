{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  config = lib.mkIf config.isGraphical {
    programs.imv.enable = isLinux;
    programs.mpv.enable = isLinux;
    programs.zathura.enable = true;

    # TODO: maybe reenable if feishin ever bumps electron
    # home.packages = lib.mkIf isLinux [ pkgs.feishin ];

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/gif" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
    };
  };
}
