{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware.nix];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "splash"];
  };

  hardware = {
    bluetooth.enable = true;
  };

  networking = {
    hostName = "bento";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    blueman.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
  };

  virtualisation.docker.enable = true;
  users.users."${config.dotfiles.username}".extraGroups = ["docker"];
}
