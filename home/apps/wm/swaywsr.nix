{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  swaywsrConfig = tomlFormat.generate "config.toml" {
    icons = with lib.icons; {
      "1Password" = _1password;
      "chrome-music.apple.com__browse-Default" = applemusic;
      "com.mitchellh.ghostty" = ghostty;
      "io.gitlab.news_flash.NewsFlash" = generic.news;
      "org.gnome.Fractal" = generic.messenger;
      "org.gnome.Nautilus" = generic.filemanager;
      "org.gnome.Podcasts" = generic.podcast;
      "org.wezfurlong.wezterm" = generic.term;
      chromium-browser = chromium;
      discord = discord;
      feishin = generic.music;
      firefox = firefox;
      foot = generic.term;
      jetbrains-idea = jetbrains-idea;
      jetbrains-rider = jetbrains-rider;
      kitty = generic.term;
      neovide = nvim;
      obsidian = obsidian;
      steam = steam;
    };
    aliases = {
      "chrome-music.apple.com__browse-Default" = "Music";
      "com.mitchellh.ghostty" = "Ghostty";
      "com.obsproject.Studio" = "OBS";
      "io.gitlab.news_flash.NewsFlash" = "NewsFlash";
      "org.gnome.Fractal" = "Fractal";
      "org.gnome.Nautilus" = "Files";
      "org.gnome.Podcasts" = "Podcasts";
      "org.wezfurlong.wezterm" = "WezTerm";
      chromium-browser = "Chromium";
      discord = "Discord";
      firefox = "Firefox";
      jetbrains-idea = "IDEA";
      jetbrains-rider = "Rider";
      neovide = "Neovide";
      obsidian = "Obsidian";
      steam = "Steam";
    };
    general.seperator = "|";
  };
in
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    xdg.configFile."swaywsr/config.toml".source = swaywsrConfig;

    systemd.user.services.swaywsr = {
      Unit = {
        Description = "Automatically change sway workspace names based on their contents";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
        X-Restart-Triggers = [
          "${config.xdg.configFile."swaywsr/config.toml".source}"
        ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.swaywsr} -r";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
