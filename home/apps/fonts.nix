{pkgs}: {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    victor-mono
    ibm-plex
    xkcd-font
  ];
}
