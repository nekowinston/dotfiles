{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  fontDirectory =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Fonts"
    else
      "${config.xdg.dataHome}/fonts";
  fontPath = ../secrets/fonts;
in
{
  config = lib.mkIf config.isGraphical {
    fonts.fontconfig = {
      enable = isLinux;
      defaultFonts = {
        sansSerif = [ "IBM Plex Sans" ];
        serif = [ "IBM Plex Serif" ];
        monospace = [ "MonaspiceXe Nerd Font Mono" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
    home.activation.installCustomFonts =
      lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
        ''
          mkdir -p "${fontDirectory}"
          install -Dm644 ${fontPath}/* "${fontDirectory}"
        '';
    home.packages = with pkgs; [
      nerd-fonts.caskaydia-cove
      nerd-fonts.blex-mono
      nerd-fonts.intone-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.monaspace
      nerd-fonts.symbols-only
      nerd-fonts.victor-mono
      ibm-plex
      monaspace
      twitter-color-emoji
      xkcd-font
    ];
  };
}
