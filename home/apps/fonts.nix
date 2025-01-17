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
        monospace = [ "Monaspace Xenon" ];
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
      cascadia-code
      ibm-plex
      intel-one-mono
      jetbrains-mono
      monaspace
      nerd-fonts.symbols-only
      twitter-color-emoji
      victor-mono
      xkcd-font
    ];
  };
}
