{ config, ... }:
let
  noQuarantine = name: {
    inherit name;
    args.no_quarantine = true;
  };
  skipSha = name: {
    inherit name;
    args.require_sha = false;
  };
in
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
      "easy-move+resize"
      "element"
      "elgato-wave-link"
      "eloston-chromium"
      "iina"
      "imageoptim"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "keka"
      "little-snitch"
      "macfuse"
      "netnewswire"
      "nextcloud"
      "obsidian"
      "orbstack"
      "orion"
      "rustdesk"
      "signal"
      (skipSha "sizzy")
      "syntax-highlight"
      "tor-browser"
      "uhk-agent"
      "uninstallpkg"
      "yubico-yubikey-manager"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
}
