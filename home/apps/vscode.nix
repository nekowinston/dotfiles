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
    package = pkgs.unstable.vscode;
    extensions = with pkgs.unstable.vscode-extensions; [
      jnoortheen.nix-ide
      matklad.rust-analyzer
      mkhl.direnv
      ms-kubernetes-tools.vscode-kubernetes-tools
      pkief.material-icon-theme
      redhat.vscode-yaml
      tamasfe.even-better-toml
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
