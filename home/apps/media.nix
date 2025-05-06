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

    programs.zathura = {
      enable = true;
      options = {
        database = "sqlite";

        adjust-open = "best-fit";
        guioptions = "s";
        scroll-page-aware = true;

        recolor = true;
        recolor-keephue = true;

        statusbar-home-tilde = true;
        window-title-basename = true;
      };
    };

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
