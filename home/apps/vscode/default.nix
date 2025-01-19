{
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

  programs.vscode = {
    enable = osConfig.dotfiles.vscode.enable;
    package = pkgs.vscodium;
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
