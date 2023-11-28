{
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./browsers.nix
    ./colorscheme-sync.nix
    ./discord.nix
    ./fonts.nix
    ./git.nix
    ./gpg.nix
    ./gtk.nix
    ./kubernetes.nix
    ./mail.nix
    ./media.nix
    ./neovim.nix
    ./newsboat.nix
    ./rice.nix
    ./sway.nix
    ./vscode.nix
    ./wezterm.nix
    ./zsh.nix
  ];

  options.isGraphical = lib.mkOption {
    default = osConfig.isGraphical;
    description = "Whether the system is a graphical target";
    type = lib.types.bool;
  };
}
