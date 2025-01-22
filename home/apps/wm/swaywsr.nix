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
      "org.gnome.Fractal" = generic.messenger;
      "org.gnome.Nautilus" = generic.filemanager;
      "org.wezfurlong.wezterm" = generic.term;
      chromium-browser = chromium;
      discord = discord;
      feishin = generic.music;
      firefox = firefox;
      foot = generic.term;
      jetbrains-idea = jetbrains-idea;
      kitty = generic.term;
      neovide = nvim;
      obsidian = obsidian;
      steam = steam;
      vesktop = discord;
      WebCord = discord;
    };
    aliases = {
      "chrome-music.apple.com__browse-Default" = "Music";
      "com.mitchellh.ghostty" = "Ghostty";
      "com.obsproject.Studio" = "OBS";
      "com.saivert.pwvucontrol" = "pwvucontrol";
      "org.gnome.Fractal" = "Fractal";
      "org.gnome.Nautilus" = "Files";
      "org.wezfurlong.wezterm" = "WezTerm";
      chromium-browser = "Chromium";
      discord = "Discord";
      firefox = "Firefox";
      jetbrains-idea = "IDEA";
      neovide = "Neovide";
      obsidian = "Obsidian";
      steam = "Steam";
      vesktop = "Discord";
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
