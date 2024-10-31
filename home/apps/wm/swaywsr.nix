{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  swaywsrConfig = tomlFormat.generate "config.toml" {
    icons = {
      "1Password" = "";
      "chrome-music.apple.com__browse-Default" = "󰝚";
      "org.gnome.Nautilus" = "󰉋";
      "org.wezfurlong.wezterm" = "";
      chromium-browser = "";
      discord = "󰙯";
      firefox = "";
      foot = "";
      kitty = "";
      neovide = "";
      obsidian = "";
      steam = "󰓓";
    };
    aliases = {
      "com.obsproject.Studio" = "OBS";
      "org.gnome.Nautilus" = "Files";
      "org.wezfurlong.wezterm" = "WezTerm";
      "chrome-music.apple.com__browse-Default" = "Music";
      chromium-browser = "Chromium";
      discord = "Discord";
      firefox = "Firefox";
      neovide = "Neovide";
      obsidian = "Obsidian";
      steam = "Steam";
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
