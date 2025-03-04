{ pkgs, ... }:
{
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    initrd.systemd.enable = true;

    supportedFilesystems = [ "ntfs" ];

    plymouth = {
      enable = true;
      themePackages = [ pkgs.plymouth-blahaj-theme ];
      theme = "blahaj";
    };
  };
}
