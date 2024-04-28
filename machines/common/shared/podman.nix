{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  environment = mkIf isDarwin {
    systemPackages = with pkgs; [
      podman
      podman-compose
      podman-tui
      qemu
    ];
    pathsToLink = ["/share/qemu"];
  };

  virtualisation.podman = mkIf isLinux {
    enable = true;
    extraPackages = with pkgs; [
      podman-compose
      podman-tui
    ];
  };
}
