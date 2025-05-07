{ pkgs, ... }:
{
  dotfiles.gaming.enable = true;

  environment.systemPackages = with pkgs; [
    libreoffice-fresh
    (prismlauncher.override {
      jdks = [ graalvmPackages.graalvm-oracle ];
      textToSpeechSupport = false;
    })
  ];
}
