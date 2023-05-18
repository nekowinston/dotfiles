{
  config,
  lib,
  pkgs,
  ...
}: {
  home.activation = {
    installCustomFonts = let
      fontDirectory =
        if pkgs.stdenv.isDarwin
        then "${config.home.homeDirectory}/Library/Fonts"
        else "${config.xdg.dataHome}/fonts";
      fontPath = ../secrets/fonts;
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        install -Dm644 ${fontPath}/* "${fontDirectory}"
      '';
  };
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    victor-mono
    ibm-plex
    xkcd-font
  ];
}
