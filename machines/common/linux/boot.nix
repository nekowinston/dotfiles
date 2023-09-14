{pkgs, ...}: {
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    initrd.systemd.enable = true;

    supportedFilesystems = ["ntfs"];

    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [pkgs.nur.repos.nekowinston.plymouth-theme-catppuccin];
    };
  };
}
