{config, ...}: {
  # make brew available in PATH
  environment.systemPath = [config.homebrew.brewPrefix];

  homebrew = {
    enable = true;
    caskArgs.require_sha = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    casks = let
      skipSha = name: {
        inherit name;
        args = {require_sha = false;};
      };
      noQuarantine = name: {
        inherit name;
        args = {no_quarantine = true;};
      };
    in [
      "1password"
      "alfred"
      "bitwarden"
      "blender"
      "docker"
      "iina"
      "imageoptim"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keka"
      "little-snitch"
      "macfuse"
      "mattermost"
      "mullvadvpn"
      "obs"
      "orion"
      "postman"
      "qutebrowser"
      "rustdesk"
      "uninstallpkg"
      "utm"
      "yubico-yubikey-manager"
      (noQuarantine "easy-move-plus-resize")
      (skipSha "affinity-designer")
      (skipSha "affinity-photo")
      (skipSha "affinity-publisher")
      (skipSha "element")
      (skipSha "sizzy")

      # drivers
      "homebrew/cask-drivers/elgato-wave-link"
      "homebrew/cask-drivers/uhk-agent"
      (noQuarantine "homebrew/cask-drivers/vial")
    ];
    taps = ["homebrew/cask"];
  };
}
