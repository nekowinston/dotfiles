{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  cfg = config.programs.vscode;

  mkSymlink = f: config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/config/${f}";

  settingsJSON = mkSymlink "settings.json";
  keybindingsJSON = mkSymlink "keybindings.json";
  snippetsDir = mkSymlink "snippets";
in
{
  home.file = lib.mkIf (cfg.enable && isDarwin) {
    "Library/Application Support/VSCodium/User/keybindings.json".source = keybindingsJSON;
    "Library/Application Support/VSCodium/User/settings.json".source = settingsJSON;
    "Library/Application Support/VSCodium/User/snippets".source = snippetsDir;
  };
  xdg.configFile = lib.mkIf (cfg.enable && isLinux) {
    "VSCodium/User/keybindings.json".source = keybindingsJSON;
    "VSCodium/User/settings.json".source = settingsJSON;
    "VSCodium/User/snippets".source = snippetsDir;
  };
}
