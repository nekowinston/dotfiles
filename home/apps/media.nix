{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  programs.imv = {
    enable = isLinux;
  };
  programs.mpv.enable = isLinux;
  programs.zathura.enable = isLinux;

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
}
