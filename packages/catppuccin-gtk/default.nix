{
  fetchzip,
  lib,
  pkgs,
  stdenv,
}: let
  flavour = "Mocha";
  accent = "Pink";
in
  stdenv.mkDerivation rec {
    name = "catppuccin-gtk";
    version = "0.4.1";

    src = fetchzip {
      url = "https://github.com/catppuccin/gtk/releases/download/v${version}/Catppuccin-${flavour}-Standard-${accent}-Dark.zip";
      sha256 = "sha256-84OpiYgzX61HoLjpF2ffQnAuL3tS1DFuDx2dHbBIog8=";
      stripRoot = false;
    };

    propagatedUserEnvPkgs = with pkgs; [
      gnome.gnome-themes-extra
      gtk-engine-murrine
    ];

    installPhase = ''
      mkdir -p "$out/share/themes"
      cp -r "Catppuccin-${flavour}-Standard-${accent}-Dark" "$out/share/themes"
    '';

    meta = with lib; {
      description = "Soothing pastel theme for GTK3";
      homepage = "https://github.com/catppuccin/gtk";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = [maintainers.nekowinston];
    };
  }
