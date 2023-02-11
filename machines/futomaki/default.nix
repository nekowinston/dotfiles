{
  config,
  pkgs,
  ...
}: let
  mainUser = "winston";

  plymouthPkg = pkgs.stdenv.mkDerivation {
    name = "plymouth-theme-catppuccin";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "plymouth";
      rev = "d4105cf336599653783c34c4a2d6ca8c93f9281c";
      sha256 = "sha256-quBSH8hx3gD7y1JNWAKQdTk3CmO4t1kVo4cOGbeWlNE=";
    };

    installPhase = ''
      mkdir -p "$out/share/plymouth/themes/"
      cp -r "themes/"* "$out/share/plymouth/themes/"
      themes=("mocha" "macchiato" "frappe" "latte")
      for dir in "''${themes[@]}"; do
        cat "themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth" | sed "s@\/usr\/@''${out}\/@" > "''${out}/share/plymouth/themes/catppuccin-''${dir}/catppuccin-''${dir}.plymouth"
      done
    '';
  };
in {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  imports = [./hardware.nix];
  environment.systemPackages = with pkgs; [xarchiver];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;

    # for nvidia & minimalism
    loader.systemd-boot.consoleMode = "0";

    # plymouth
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [plymouthPkg];
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

  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
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
        gdm.enable = true;
      };
      libinput.enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.unstable.i3;
        extraPackages = with pkgs; [
          dmenu
          pavucontrol
          xclip
          xdotool
        ];
      };
      xkbOptions = "caps:ctrl_modifier";
    };
  };

  virtualisation.docker.enable = true;

  users.users."${mainUser}" = {
    extraGroups = ["wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILm0O46zW/XfVOSwz0okRWYeOAg+wCVkCtCAoVTpZsOh"];
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.11";
}
