{
  config,
  pkgs,
  ...
}: let
  mainUser = "winston";
in {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  imports = [./hardware.nix];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;

    # for nvidia & minimalism
    loader.systemd-boot.consoleMode = "0";

    # plymouth
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [pkgs.nur.repos.nekowinston.plymouth-theme-catppuccin];
    };
    kernelParams = ["quiet" "splash" "vt.global_cursor_default=0"];
    initrd.systemd.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };

  networking = {
    hostName = "futomaki";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    noisetorch.enable = true;
    steam.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  security.polkit.enable = true;
  systemd = {
    packages = [pkgs.polkit_gnome];
    user.services.polkit-gnome-authentication-agent-1 = {
      unitConfig = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = ["graphical-session.target"];
        WantedBy = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    # mounting
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    # desktop
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    mullvad-vpn.enable = true;
    pipewire.enable = true;

    openssh.enable = true;
    pcscd.enable = true;

    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
        lightdm.background = "#000000";
      };
      libinput.enable = true;
      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.unstable.i3;
      xkbOptions = "caps:ctrl_modifier";
    };
  };

  virtualisation.docker.enable = true;

  users.users."${mainUser}" = {
    extraGroups = ["wheel" "docker"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm0O46zW/XfVOSwz0okRWYeOAg+wCVkCtCAoVTpZsOh"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.11";
}
