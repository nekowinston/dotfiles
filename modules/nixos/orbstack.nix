{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.orbstack;

  inherit (config.dotfiles) username;
  inherit (lib) mkForce;
in
{
  options.dotfiles.orbstack.enable = lib.mkEnableOption "OrbStack specific configuration";

  config = lib.mkIf cfg.enable {

    ### Orbstack-generated configuration
    # Add OrbStack CLI tools to PATH
    environment.shellInit = ''
      . /opt/orbstack-guest/etc/profile-early

      # add your customizations here

      . /opt/orbstack-guest/etc/profile-late
    '';

    # Disable systemd-resolved
    services.resolved.enable = false;
    environment.etc."resolv.conf".source = "/opt/orbstack-guest/etc/resolv.conf";

    # Faster DHCP - OrbStack uses SLAAC exclusively
    networking.dhcpcd.extraConfig = ''
      noarp
      noipv6
    '';
    networking = {
      # dhcpcd.enable = false;
      useDHCP = false;
      useHostResolvConf = false;
    };

    # Disable sshd
    services.openssh.enable = false;

    # ssh config
    programs.ssh.extraConfig = ''
      Include /opt/orbstack-guest/etc/ssh_config
    '';

    # indicate builder support for emulated architectures
    nix.settings.extra-platforms = [
      "x86_64-linux"
      "i686-linux"
    ];

    ### manual configuration
    # turn off boot config
    boot.plymouth.enable = mkForce false;
    system.build.installBootLoader = mkForce "${pkgs.coreutils}/bin/true";

    # turn off fs support
    boot.supportedFilesystems = mkForce [ ];

    # map the user to the macOS uid
    users = {
      users.${username} = {
        uid = 501;
        extraGroups = [ "wheel" ];

        # simulate isNormalUser, but with an arbitrary UID
        isSystemUser = mkForce true;
        isNormalUser = mkForce false;
        group = "users";
        createHome = true;
        home = "/home/${username}";
        homeMode = "700";
        useDefaultShell = true;
      };
      # This being `true` leads to a few nasty bugs, change at your own risk!
      mutableUsers = false;
    };
    security.sudo.wheelNeedsPassword = false;

    virtualisation.podman.enable = mkForce false;
    services.unbound.enable = mkForce false;
  };
}
