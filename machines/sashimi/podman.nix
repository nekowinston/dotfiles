{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      podman
      podman-compose
      podman-tui
      qemu
    ];
    pathsToLink = [ "/share/qemu" ];
  };
}
