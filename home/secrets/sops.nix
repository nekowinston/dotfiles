{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  # TODO: make this accept more than just otf
  fontMapping = fontname: {
    path =
      if isLinux
      then "${config.xdg.dataHome}/fonts/${fontname}.otf"
      else if isDarwin
      then "${config.home.homeDirectory}/Library/Fonts/${fontname}.otf"
      else throw "Unsupported platform";
    format = "binary";
    sopsFile = ./fonts/${fontname}.json;
  };
in {
  sops = {
    gnupg.home = "${config.xdg.configHome}/gnupg";
    defaultSopsFile = ./main.yaml;
    secrets = {
      "kubeconfig".path = "${config.xdg.configHome}/kube/kubeconfig";
      "berkeley_regular" = fontMapping "berkeley_regular";
      "berkeley_italic" = fontMapping "berkeley_italic";
      "berkeley_bold" = fontMapping "berkeley_bold";
      "berkeley_bold_italic" = fontMapping "berkeley_bold_italic";
      "comic_code_regular" = fontMapping "comic_code_regular";
      "comic_code_italic" = fontMapping "comic_code_italic";
      "comic_code_medium" = fontMapping "comic_code_medium";
      "comic_code_medium_italic" = fontMapping "comic_code_medium_italic";
      "comic_code_bold" = fontMapping "comic_code_bold";
      "comic_code_bold_italic" = fontMapping "comic_code_bold_italic";
    };
  };
}
