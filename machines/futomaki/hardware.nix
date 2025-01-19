{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [
      "dm-snapshot"
      "i915" # early Intel graphics
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-amd"
      "nct6775"
      "v4l2loopback"
    ];
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  hardware.bluetooth.enable = true;

  # Intel Arc A770
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vaapiIntel
      vpl-gpu-rt
    ];
  };

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md0 level=raid1 num-devices=2 metadata=1.2 UUID=ce2bd085:2b7e0014:c58c6c06:10223743
          devices=/dev/sda1,/dev/sdb1
    '';
  };
  boot.initrd.luks.devices = {
    "root" = {
      device = "/dev/disk/by-uuid/b9e2d484-b41e-437f-bc98-8b48383f1613";
      allowDiscards = true;
      preLVM = true;
    };
    "raid" = {
      device = "/dev/disk/by-uuid/e6d39800-4e2b-4a03-b504-abe3beed0404";
      allowDiscards = true;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1C5A-3C51";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-uuid/8f9c9b30-a046-4c30-acce-db3e771aaadc";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
    "/data/ssd-raid" = {
      device = "/dev/disk/by-uuid/dce157dd-5d1c-4086-a60c-17f6aa50c256";
      options = [ "nofail" ];
    };
  };
}
