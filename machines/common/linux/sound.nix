{config, ...}: {
  programs.noisetorch.enable = config.isGraphical;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = config.isGraphical;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
