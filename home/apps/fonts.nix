{
  config,
  flakePath,
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
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        install -Dm644 ${flakePath}/home/secrets/fonts/* "${fontDirectory}"
      '';
  };
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    victor-mono
    ibm-plex
    xkcd-font
  ];
}
