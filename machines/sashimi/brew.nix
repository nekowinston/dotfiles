{config, ...}: let
  noQuarantine = name: {
    inherit name;
    args.no_quarantine = true;
  };
  skipSha = name: {
    inherit name;
    args.require_sha = false;
  };
in {
  # make brew available in PATH
  environment.systemPath = [config.homebrew.brewPrefix];

  homebrew = {
    enable = true;
    caskArgs.require_sha = true;
    brews = [
      "podman"
      "podman-compose"
    ];
    casks = [
      "1password"
      (skipSha "affinity-designer")
      (skipSha "affinity-photo")
      (skipSha "affinity-publisher")
      "alfred"
      "azure-data-studio"
      "blender"
      (noQuarantine "easy-move-plus-resize")
      (skipSha "element")
      "elgato-wave-link"
      "eloston-chromium"
      "iina"
      "imageoptim"
      "jetbrains-toolbox"
      "keka"
      "little-snitch"
      "macfuse"
      "mullvad-browser"
      "mullvadvpn"
      "rustdesk"
      "signal"
      (skipSha "sizzy")
      "uhk-agent"
      "uninstallpkg"
      "utm"
      "yubico-yubikey-manager"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    taps = ["homebrew/cask"];
  };
}
