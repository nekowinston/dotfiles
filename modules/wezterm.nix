{ config, machine, ... }:

{
  xdg.configFile = {
    "wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${machine.flakePath}/modules/wezterm";
      recursive = true;
    };
  };
}
