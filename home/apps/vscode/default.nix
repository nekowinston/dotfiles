{
  config,
  pkgs,
  osConfig ? {
    dotfiles = {
      wsl = {
        enable = false;
      };
    };
  },
  ...
}:
{
  imports = [
    ./extensions.nix
    ./symlinks.nix
  ];

  programs.vscode = {
    enable = config.isGraphical;
    package = pkgs.vscodium;
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";

  # enable VSCode server to allow editing on Windows, when running in WSL
  services.vscode-server.enable = osConfig.dotfiles.wsl.enable;
}
