{
  config,
  flakePath,
  ...
}: {
  home.sessionVariables = {TERMINAL = "wezterm";};

  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/wezterm";
    recursive = true;
  };
}
