{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-amd"
      "v4l2loopback"
    ];
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  # Intel Arc A770
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
  };

  hardware.bluetooth.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/018963d2-463f-451d-a54c-dc6f29f24daa";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-b8839f86-af3a-4cb7-a906-108ece087aa0".device = "/dev/disk/by-uuid/b8839f86-af3a-4cb7-a906-108ece087aa0";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1D0D-B170";
    fsType = "vfat";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
