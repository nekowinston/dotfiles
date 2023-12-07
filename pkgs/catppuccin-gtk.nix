{
  pkgs ? import <nixpkgs> {},
  accents ? ["pink"],
  size ? "compact",
  lightFlavor ? "latte",
  darkFlavor ? "mocha",
}: let
  capitalize = s: (pkgs.lib.toUpper (builtins.substring 0 1 s)) + (builtins.substring 1 (builtins.stringLength s) s);
  darkName = capitalize darkFlavor;
  lightName = capitalize lightFlavor;
in
  pkgs.symlinkJoin {
    name = "Catppuccin-Compact-Pink";
    paths = [
      (pkgs.catppuccin-gtk.override {
        inherit accents size;
        variant = darkFlavor;
      })
      (pkgs.catppuccin-gtk.override {
        inherit accents size;
        variant = lightFlavor;
      })
    ];
    postBuild = ''
      cd $out/share/themes
      mv -v Catppuccin-${lightName}-Compact-Pink-Light       Catppuccin-Compact-Pink
      mv -v Catppuccin-${lightName}-Compact-Pink-Light-hdpi  Catppuccin-Compact-Pink-hdpi
      mv -v Catppuccin-${lightName}-Compact-Pink-Light-xhdpi Catppuccin-Compact-Pink-xhdpi
      mv -v Catppuccin-${darkName}-Compact-Pink-Dark         Catppuccin-Compact-Pink-dark
      mv -v Catppuccin-${darkName}-Compact-Pink-Dark-hdpi    Catppuccin-Compact-Pink-hdpi-dark
      mv -v Catppuccin-${darkName}-Compact-Pink-Dark-xhdpi   Catppuccin-Compact-Pink-xhdpi-dark
    '';
  }
