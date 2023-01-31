{ pkgs, ... }:

with lib; let
  cfg = config.catppuccin;
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
      vim_keys = true;
    };
  };

  xdg.configFile."btop/themes" = {
    source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "btop";
      rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
      sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
    };
  };
}
