{...}: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls = [
      {url = "https://blog.gitea.io/index.xml";}
      {url = "https://neomutt.org/feed.xml";}
      {url = "https://this-week-in-neovim.org/rss";}
    ];
  };
}
