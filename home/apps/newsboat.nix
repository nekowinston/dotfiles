{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser =
      if isLinux
      then (lib.getExe pkgs.xdg-utils)
      else "open";
    urls = [
      {
        url = "https://blog.gitea.io/index.xml";
        title = "Gitea Blog";
      }
      {
        title = "Gitea Helm Chart";
        url = "https://gitea.com/gitea/helm-chart/releases.rss";
      }
      {
        title = "Neomutt";
        url = "https://neomutt.org/feed.xml";
      }
      {
        title = "This Week in Neovim";
        url = "https://this-week-in-neovim.org/rss";
      }
      {
        title = "XKCD";
        url = "https://xkcd.com/rss.xml";
      }
    ];
    extraConfig = ''
      bind-key j down feedlist
      bind-key k up feedlist
      bind-key j next articlelist
      bind-key k prev articlelist
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key j down article
      bind-key k up article

      unbind-key C feedlist
      confirm-exit no
    '';
  };
}
