{
  config,
  flakePath,
  ...
}: {
  xdg.configFile = {
    "wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/wezterm";
      recursive = true;
    };
  };
}
