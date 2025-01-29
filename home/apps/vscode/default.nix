{
  lib,
  osConfig ? {
    dotfiles.vscode.enable = false;
  },
  pkgs,
  ...
}:
{
  imports = [
    ./extensions.nix
    ./symlinks.nix
  ];

  config = lib.mkIf osConfig.dotfiles.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

    xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
  };
}
