{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];
  dotfiles.orbstack.enable = true;

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  system.stateVersion = "24.05";
}
