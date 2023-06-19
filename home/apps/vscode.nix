{
  config,
  flakePath,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions.vscode-marketplace; [
      jnoortheen.nix-ide
      mkhl.direnv
      ms-kubernetes-tools.vscode-kubernetes-tools
      pkief.material-icon-theme
      redhat.vscode-yaml
      rust-lang.rust-analyzer
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
  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
