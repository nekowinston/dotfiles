{ config, ... }:
{
  # make brew available in PATH
  environment.systemPath = [ config.homebrew.brewPrefix ];

  homebrew = {
    enable = true;
    caskArgs.require_sha = true;
    brews = [ ];
    casks = [
      "1password"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "alfred"
      "blender"
      "discord"
      "easy-move+resize"
      "element"
      "elgato-wave-link"
      "eloston-chromium"
      "firefox"
      "iina"
      "imageoptim"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "keka"
      "little-snitch"
      "macfuse"
      "netnewswire"
      "nextcloud"
      "obs"
      "obsidian"
      "orbstack"
      "rustdesk"
      "setapp"
      "signal"
      "syntax-highlight"
      "tor-browser"
      "uhk-agent"
      "uninstallpkg"
      "whisky"
      "yubico-yubikey-manager"
      "zulip"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
