{ config, ... }:

{
  xdg.configFile = {
    "wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink ./wezterm;
      recursive = true;
    };
  };
}
