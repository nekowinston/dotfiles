{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.wsl;
  inherit (lib) mkDefault mkForce;
in
{
  options.dotfiles.wsl.enable = lib.mkEnableOption "NixOS-WSL specific options";

  config = lib.mkIf cfg.enable {
    # disable services that are not needed in WSL
    services = {
      dnsmasq.enable = mkForce false;
      kanata.enable = mkForce false;
      mullvad-vpn.enable = mkForce false;
      stubby.enable = mkForce false;
    };

    # podman runs on native Windows
    virtualisation.podman.enable = mkForce false;

    # main WSL defaults
    wsl = {
      enable = mkDefault true;
      defaultUser = mkDefault config.dotfiles.username;
      startMenuLaunchers = mkDefault true;
      useWindowsDriver = mkDefault true;
    };

    # skip installing the bootloader
    system.build.installBootLoader = mkForce "${pkgs.coreutils}/bin/true";
  };
}
