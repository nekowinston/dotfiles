{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  kernel = pkgs.linuxPackages_6_3;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelPackages = kernel;
    kernelModules = ["kvm-amd" "v4l2loopback"];
    kernelParams = ["quiet" "splash"];
  };

  # Intel Arc A770
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  boot.extraModulePackages = [kernel.v4l2loopback];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.bluetooth.enable = true;

  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/170cdc3f-2b04-4123-93ea-5e03136f6548";
      preLVM = true;
      allowDiscards = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/894ceea3-0596-4652-89fd-772fbb82474c";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/894ceea3-0596-4652-89fd-772fbb82474c";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/894ceea3-0596-4652-89fd-772fbb82474c";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D3BE-5F94";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/72a4ce61-6cb8-4996-9966-83de91a49b6c";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
