{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  cfg = config.programs.newsboat;
in
{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = if isLinux then "${pkgs.xdg-utils}/bin/xdg-open" else "open";
    extraConfig = ''
      urls-source "freshrss"
      freshrss-url "https://freshrss.winston.sh/api/greader.php"
      freshrss-login "winston"
      freshrss-passwordeval "gopass -o freshrss"

      bind-key j down feedlist
      bind-key k up feedlist
      bind-key j next articlelist
      bind-key k prev articlelist
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key j down article
      bind-key k up article

      macro m set browser "mpv %u &"; open-in-browser-noninteractively; set browser "${cfg.browser}"

      unbind-key C feedlist
      confirm-exit no
    '';
  };
}
