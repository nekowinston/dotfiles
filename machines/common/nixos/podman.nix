{ pkgs, ... }:
{
  virtualisation.podman.extraPackages = with pkgs; [
    podman-compose
    podman-tui
  ];
}
