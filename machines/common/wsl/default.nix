{
  lib,
  pkgs,
  ...
}: {
  services.kanata.enable = lib.mkForce false;

  system = {
    build.installBootLoader = lib.mkForce "${pkgs.coreutils}/bin/true";
    stateVersion = "23.11";
  };
}
