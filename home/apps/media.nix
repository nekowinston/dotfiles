{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  programs.mpv.enable = isLinux;
  programs.zathura.enable = isLinux;

  services.discord-applemusic-rich-presence.enable = isDarwin;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zathura.desktop";
    "video/mp4" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
  };
}
