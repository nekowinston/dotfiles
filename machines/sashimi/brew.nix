{
  homebrew = {
    enable = true;
    caskArgs = {
      require_sha = true;
    };
    onActivation.autoUpdate = true;
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
      "discord"
      "docker"
      "firefox"
      "imageoptim"
      "insomnia"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keepassxc"
      "keka"
      "little-snitch"
      "mattermost"
      "mullvadvpn"
      "obs"
      "postman"
      "qt-creator"
      "rustdesk"
      "uninstallpkg"
      "utm"
      "yubico-yubikey-manager"
      (noQuarantine "easy-move-plus-resize")
      (noQuarantine "eloston-chromium")
      (skipSha "affinity-designer")
      (skipSha "affinity-photo")
      (skipSha "affinity-publisher")
      (skipSha "sizzy")

      # drivers
      "elgato-wave-link"
      "uhk-agent"
      (noQuarantine "vial")
    ];
    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
    ];
  };
}
