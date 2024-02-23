{
  lib,
  pkgs,
  ...
}: {
  services = {
    kanata.enable = lib.mkForce false;
    dnsmasq.enable = lib.mkForce false;
    mullvad-vpn.enable = lib.mkForce false;
    stubby.enable = lib.mkForce false;
  };

  system = {
    build.installBootLoader = lib.mkForce "${pkgs.coreutils}/bin/true";
    stateVersion = "23.11";
  };
}
