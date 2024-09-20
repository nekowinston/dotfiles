{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    extraPackages = with pkgs; [
      podman-compose
      podman-tui
    ];
  };
}
