{
  config,
  pkgs,
  ...
}:
let
  isWindowManager =
    config.wayland.windowManager.hyprland.enable || config.wayland.windowManager.sway.enable;

  inherit (config.fonts.fontconfig) defaultFonts;
  fontSans = builtins.head defaultFonts.sansSerif;

  darkColors = # css
    ''
      * {
        bg-col:  #1c2127;
        bg-col-light: #404854;
        border-col: #ff66a1;
        selected-col: #d3d8de;
        blue: #8abbff;
        fg-col: #ffffff;
        gray: #c5cbd3;
      }
    '';
  lightColors = # css
    ''
      * {
        bg-col:  #f6f7f9;
        bg-col-light: #d3d8de;
        border-col: #db2c6f;
        selected-col: #404854;
        blue: #2d72d2;
        fg-col: #111418;
        gray: #5f6b7c;
      }
    '';
  style = # css
    ''
      element-text, element-icon, mode-switcher {
        background-color: inherit;
        text-color:       inherit;
      }

      window {
        height: 360px;
        border: 3px;
        border-color: @border-col;
        background-color: @bg-col;
      }

      mainbox {
        background-color: @bg-col;
      }

      inputbar {
        children: [prompt, entry];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
      }

      prompt {
        background-color: @blue;
        padding: 6px;
        text-color: @bg-col;
        margin: 20px 0px 0px 20px;
      }

      textbox-prompt-colon {
        expand: false;
        str: ":";
      }

      entry {
        padding: 6px;
        margin: 20px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
      }

      listview {
        border: 0px 0px 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 20px;
        columns: 2;
        lines: 5;
        background-color: @bg-col;
      }

      element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col;
      }

      element-icon {
        size: 25px;
      }

      element selected {
        background-color:  @selected-col;
        text-color: @bg-col;
      }

      mode-switcher {
        spacing: 0;
      }

      button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @gray;
        vertical-align: 0.5;
        horizontal-align: 0.5;
      }

      button selected {
        background-color: @bg-col;
        text-color: @blue;
      }

      message {
        background-color: @bg-col-light;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
      }

      textbox {
        padding: 6px;
        margin: 20px 0px 0px 20px;
        text-color: @blue;
        background-color: @bg-col-light;
      }
    '';
  darkCss = pkgs.writeText "rofi-dark.rasi" (darkColors + style);
  lightCss = pkgs.writeText "rofi-light.rasi" (lightColors + style);
in
{
  programs.rofi = {
    enable = isWindowManager;
    package = pkgs.rofi-wayland;
    font = "${fontSans} 14";
    extraConfig.icon-theme = config.gtk.iconTheme.name;
    terminal = "kitty";
    theme = "custom";
  };
  services.darkman = {
    darkModeScripts.rofi = # bash
      ''
        mkdir -p ~/.local/share/rofi/themes
        ln -sf ${darkCss} ~/.local/share/rofi/themes/custom.rasi
      '';
    lightModeScripts.rofi = # bash
      ''
        mkdir -p ~/.local/share/rofi/themes
        ln -sf ${lightCss} ~/.local/share/rofi/themes/custom.rasi
      '';
  };
}
