{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  mkSymlink = f: config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/config/${f}";

  settingsJSON = mkSymlink "settings.json";
  keybindingsJSON = mkSymlink "keybindings.json";
  snippetsDir = mkSymlink "snippets";
in
{
  home.file = lib.mkIf isDarwin {
    "Library/Application Support/VSCodium/User/keybindings.json".source = keybindingsJSON;
    "Library/Application Support/VSCodium/User/settings.json".source = settingsJSON;
    "Library/Application Support/VSCodium/User/snippets".source = snippetsDir;
  };
  xdg.configFile = lib.mkIf isLinux {
    "VSCodium/User/keybindings.json".source = keybindingsJSON;
    "VSCodium/User/settings.json".source = settingsJSON;
    "VSCodium/User/snippets".source = snippetsDir;
  };
}
