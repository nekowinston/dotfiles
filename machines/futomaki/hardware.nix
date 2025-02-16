{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
  };

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
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-amd"
      "nct6775"
    ];
    kernelParams = [
      "quiet"
      "splash"
    ];
    plymouth.extraConfig = ''
      DeviceScale=2
    '';
  };

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      PROGRAM ${pkgs.coreutils}/bin/true
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
