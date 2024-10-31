{ config, ... }:
{
  services = {
    clipman.enable = true;
    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    wlsunset = {
      enable = true;
      latitude = toString config.location.latitude;
      longitude = toString config.location.longitude;
    };
    udiskie.enable = true;
  };
}
