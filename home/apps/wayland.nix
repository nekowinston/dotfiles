{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  home.packages = lib.mkIf isLinux (with pkgs; [
    clipman
    wl-clipboard
  ]);
}
