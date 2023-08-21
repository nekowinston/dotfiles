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
    brews = [
      # D development, might make these Nix packages someday when the ecosystem isn't as horrid
      "dfmt"
      "dcd"
      "dub"
      "ldc"
    ];
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
      "postman"
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
      "elgato-wave-link"
      "uhk-agent"
      (noQuarantine "vial")
    ];
    taps = ["homebrew/cask" "homebrew/cask-drivers"];
  };
}
