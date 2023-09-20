{
  inputs,
  pkgs,
  ...
}: {
  home = {
    packages = [
      inputs.neovim.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    ];
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
