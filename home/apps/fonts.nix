{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.isGraphical {
    home.activation = {
      installCustomFonts = let
        fontDirectory =
          if pkgs.stdenv.isDarwin
          then "${config.home.homeDirectory}/Library/Fonts"
          else "${config.xdg.dataHome}/fonts";
        fontPath = ../secrets/fonts;
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p "${fontDirectory}"
          install -Dm644 ${fontPath}/* "${fontDirectory}"
        '';
    };
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      cascadia-code
      victor-mono
      ibm-plex
      xkcd-font
    ];
  };
}
