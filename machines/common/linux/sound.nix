{
  programs.noisetorch.enable = true;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
