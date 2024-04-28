{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  services = {
    kanata.enable = mkForce false;
    dnsmasq.enable = mkForce false;
    mullvad-vpn.enable = mkForce false;
    stubby.enable = mkForce false;
  };
  virtualisation.podman.enable = mkForce false;

  system = {
    build.installBootLoader = mkForce "${pkgs.coreutils}/bin/true";
    stateVersion = "23.11";
  };
}
