{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  icons = {
    discord = "󰙯";
    nvim = "";
    term = "";
  };
  swaywsrConfig = tomlFormat.generate "config.toml" {
    icons = {
      "1Password" = "";
      "chrome-music.apple.com__browse-Default" = "";
      "org.gnome.Fractal" = "";
      "org.gnome.Nautilus" = "󰉋";
      "org.wezfurlong.wezterm" = icons.term;
      chromium-browser = "";
      discord = icons.discord;
      firefox = "";
      foot = icons.term;
      kitty = icons.term;
      neovide = icons.nvim;
      obsidian = "";
      steam = "󰓓";
      vesktop = icons.discord;
    };
    aliases = {
      "com.obsproject.Studio" = "OBS";
      "org.gnome.Fractal" = "Fractal";
      "org.gnome.Nautilus" = "Files";
      "org.wezfurlong.wezterm" = "WezTerm";
      "chrome-music.apple.com__browse-Default" = "Music";
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
