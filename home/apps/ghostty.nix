{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib) mkIf mkMerge;

  keybind = (builtins.map (i: "alt+${toString i}=unbind") (lib.range 0 9)) ++ [
    "ctrl+s>c=new_tab"
    "ctrl+s>x=close_surface"
    "ctrl+s>1=goto_tab:1"
    "ctrl+s>2=goto_tab:2"
    "ctrl+s>3=goto_tab:3"
    "ctrl+s>4=goto_tab:4"
    "ctrl+s>5=goto_tab:5"
    "ctrl+s>6=goto_tab:6"
    "ctrl+s>7=goto_tab:7"
    "ctrl+s>8=goto_tab:8"
    "ctrl+s>9=goto_tab:9"
    "ctrl+s>0=goto_tab:10"
    # split navigation
    "ctrl+s>\\=new_split:right"
    "ctrl+s>-=new_split:down"
    "ctrl+s>h=goto_split:left"
    "ctrl+s>j=goto_split:bottom"
    "ctrl+s>k=goto_split:top"
    "ctrl+s>l=goto_split:right"
    "ctrl+s>shift+h=resize_split:left,10"
    "ctrl+s>shift+j=resize_split:down,10"
    "ctrl+s>shift+k=resize_split:up,10"
    "ctrl+s>shift+l=resize_split:right,10"
  ];
in
{
  programs.ghostty = {
    enable = config.isGraphical;
    settings = mkMerge [
      {
        font-family = "TX-02";
        font-size = 12;
        theme = "light:milspec-light,dark:milspec-dark";

        mouse-hide-while-typing = true;

        inherit keybind;
      }
      (mkIf isLinux {
        adw-toolbar-style = "flat";
        gtk-tabs-location = "bottom";
        gtk-wide-tabs = false;
        window-decoration = false;

        linux-cgroup = "always";
      })
      (mkIf isDarwin {
        macos-auto-secure-input = true;
        macos-icon-frame = "chrome";
        macos-titlebar-style = "hidden";
      })
    ];
    themes = {
      milspec-dark = {
        background = "1c2127";
        foreground = "ffffff";

        cursor-invert-fg-bg = true;
        selection-background = "404854";
        selection-foreground = "ffffff";

        palette = [
          "0=#1c2127"
          "8=#c5cbd3"

          "1=#fa999c"
          "9=#ff9980"

          "2=#72ca9b"
          "10=#62d96b"

          "3=#fbb360"
          "11=#d0b090"

          "4=#8abbff"
          "12=#68c1ee"

          "5=#ff66a1"
          "13=#d69fd6"

          "6=#68c1ee"
          "14=#7ae1d8"

          "7=#ffffff"
          "15=#c5cbd3"
        ];
      };
      milspec-light = {
        background = "f6f7f9";
        foreground = "111418";

        cursor-invert-fg-bg = true;
        selection-background = "d3d8de";
        selection-foreground = "111418";

        palette = [
          "0=#f6f7f9"
          "8=#5f6b7c"

          "1=#cd4246"
          "9=#d33d17"

          "2=#238551"
          "10=#29a634"

          "3=#c87619"
          "11=#946638"

          "4=#2d72d2"
          "12=#147eb3"

          "5=#db2c6f"
          "13=#9d3f9d"

          "6=#147eb3"
          "14=#00a396"

          "7=#111418"
          "15=#5f6b7c"
        ];
      };
    };
  };
}
