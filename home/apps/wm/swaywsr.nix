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
      "org.gnome.Fractal" = generic.messenger;
      "org.gnome.Nautilus" = generic.filemanager;
      "org.wezfurlong.wezterm" = generic.term;
      chromium-browser = chromium;
      discord = discord;
      firefox = firefox;
      foot = generic.term;
      kitty = generic.term;
      neovide = nvim;
      obsidian = obsidian;
      steam = steam;
      vesktop = discord;
    };
    aliases = {
      "chrome-music.apple.com__browse-Default" = "Music";
      "com.obsproject.Studio" = "OBS";
      "com.saivert.pwvucontrol" = "pwvucontrol";
      "org.gnome.Fractal" = "Fractal";
      "org.gnome.Nautilus" = "Files";
      "org.wezfurlong.wezterm" = "WezTerm";
      chromium-browser = "Chromium";
      discord = "Discord";
      firefox = "Firefox";
      neovide = "Neovide";
      obsidian = "Obsidian";
      steam = "Steam";
      vesktop = "Vesktop";
    };
    general.seperator = "|";
  };
in
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    wayland.windowManager.sway.config.startup = [
      { command = "${lib.getExe pkgs.swaywsr} -r"; }
    ];
    xdg.configFile."swaywsr/config.toml".source = swaywsrConfig;
  };
}
