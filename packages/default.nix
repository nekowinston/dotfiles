final: prev: {
  cura = prev.callPackage ./cura {};
  discord-applemusic-rich-presence = prev.callPackage ./discord-applemusic-rich-presence {};
  emmet-ls = prev.callPackage ./emmet-ls {};
  helm-ls = prev.callPackage ./helm-ls {};
  jq-lsp = prev.callPackage ./jq-lsp {};
  mopidy-podcast-itunes = prev.callPackage ./mopidy-podcast-itunes {};
  org-stats = prev.callPackage ./org-stats {};
  papirus-folders-catppuccin = prev.callPackage ./papirus-folders-catppuccin {};
  catppuccin-catwalk = prev.callPackage ./python3Packages/catppuccin-catwalk {};
  discover-overlay = prev.callPackage ./python3Packages/discover-overlay {};
  picom = prev.picom.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "FT-Labs";
      repo = "picom";
      sha256 = "sha256-MRCffxU0X5a368zJGwzcv25P2ZYyAI31EOBhgiyR71A=";
      rev = "c9aee893d2ab0acc4e997dc4186e7b1ef344ac0f";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [prev.pcre2];
  });
}
