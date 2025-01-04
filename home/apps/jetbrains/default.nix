{ config, flakePath, ... }:
{
  xdg.configFile."ideavim/ideavimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/jetbrains/config/ideavimrc";
}
