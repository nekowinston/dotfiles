{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  # Discord is installed via Brew on macOS atm
  config = lib.mkIf (config.isGraphical && isLinux) {
    home.packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withTTS = false;
      })
      pkgs.discover-overlay
    ];
  };
}
