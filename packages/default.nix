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
    version = "unstable-2022-02-06";
    src = prev.fetchFromGitHub {
      owner = "FT-Labs";
      repo = "picom";
      sha256 = "sha256-uH0OuM36xnvGC6TMJ7r7nlx8ZUGgL8N6ia/6KzFksVY=";
      rev = "bb2b4801f7aef81f0739a50bf272431f7d7d9549";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [prev.pcre2];
  });
}
