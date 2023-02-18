{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      pkgs.nur.repos.nekowinston.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
      pkief.material-icon-theme
      redhat.vscode-yaml
      valentjn.vscode-ltex
      vscodevim.vim
    ];
    mutableExtensionsDir = true;
  };
  home.file = {
    "${config.xdg.configHome}/Code/User/settings.json" = {
      enable = isLinux;
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/settings.json";
    };
    "Library/Application Support/Code/User/settings.json" = {
      enable = isDarwin;
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/vscode/settings.json";
    };
  };
}
