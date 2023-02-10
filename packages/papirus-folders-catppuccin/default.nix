{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  papirus-icon-theme,
  gtk3,
  bash,
  getent,
  flavor ? "mocha",
  accent ? "blue",
  ...
}: let
  validAccents = ["blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"];
  validFlavors = ["latte" "frappe" "macchiato" "mocha"];
  pname = "catppuccin-papirus-folders";
in
  lib.checkListOfEnum "${pname}: accent color" validAccents [accent]
  lib.checkListOfEnum "${pname}: flavor"
  validFlavors [flavor]
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "unstable-2022-12-04";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "papirus-folders";
      rev = "1a367642df9cf340770bd7097fbe85b9cea65bcb";
      sha256 = "sha256-mFDfRVDA9WyriyFVzsI7iqmPopN56z54FvLkZDS2Dv8=";
    };

    buildInputs = [bash getent gtk3 papirus-icon-theme];

    patchPhase = ''
      substituteInPlace ./papirus-folders --replace "getent" "${getent}/bin/getent"
    '';

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r ${papirus-icon-theme}/share/icons/Papirus* $out/share/icons
      chmod -R u+rw $out
      cp -r src/* $out/share/icons/Papirus
      for theme in $out/share/icons/*; do
        ${bash}/bin/bash ./papirus-folders -t $theme -o -C cat-${flavor}-${accent}
        gtk-update-icon-cache --force $theme
      done
    '';

    meta = with lib; {
      description = "Soothing pastel theme for Papirus Icon Theme folders";
      homepage = "https://github.com/catppuccin/papirus-folders";
      license = licenses.mit;
      maintainers = [maintainers.nekowinston];
    };
  }
