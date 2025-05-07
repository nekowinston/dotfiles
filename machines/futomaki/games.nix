{ pkgs, ... }:
{
  dotfiles.gaming.enable = true;

  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      jdks = [ graalvmPackages.graalvm-oracle ];
      textToSpeechSupport = false;
    })
  ];
}
