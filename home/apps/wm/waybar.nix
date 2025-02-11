{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isHyprland = config.wayland.windowManager.hyprland.enable;
  isSway = config.wayland.windowManager.sway.enable;
  isSwayFx = osConfig.dotfiles.desktop == "swayfx";

  commonSettings = {
    layer = "top";
    position = "top";

    height = 32;
    spacing = 2;
    margin = lib.mkIf isSwayFx "2";

    modules-right = [
      "systemd-failed-units"
      "cpu"
      "memory"
      "tray"
      "idle_inhibitor"
      "bluetooth"
      "pulseaudio"
      "clock"
      (lib.mkIf config.services.swaync.enable "custom/swaync")
    ];

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "󰒲";
      };
    };

    tray.spacing = 10;

    pulseaudio = {
      format = "{icon} {volume}%";
      format-icons.default = [
        ""
        ""
        ""
      ];
      on-click = "swaysettings -p sound";
    };

    bluetooth = lib.mkIf osConfig.hardware.bluetooth.enable {
      format = "";
      format-disabled = "";
      format-connected = " {num_connections}";
      tooltip-format = "{controller_alias}\t{controller_address}";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      on-click = "swaysettings -p bluetooth";
    };

    mpris = {
      format = "";
      format-playing = "{dynamic}";
      tooltip = false;
      dynamic-order = [
        "artist"
        "title"
      ];
    };

    cpu = {
      interval = 5;
      format = "  {usage:2}%";
    };

    memory = {
      interval = 5;
      format = "  {percentage:2}%";
    };

    systemd-failed-units = {
      hide-on-ok = true;
      format = " {nr_failed}";
      system = true;
      user = true;
    };
  };

  inherit (config.fonts.fontconfig) defaultFonts;
  fontSans = builtins.head defaultFonts.sansSerif;

  boolString = cond: if cond then "true" else "false";
  buildStyle =
    appearance:
    pkgs.runCommandNoCC "hm_waybarstyle${appearance}.css" {
      nativeBuildInputs = [ pkgs.dart-sass ];
      style = # scss
        ''
          @use "${./scss}/waybar";

          @include waybar.main(
            $fancy: ${boolString isSwayFx},
            $dark: ${boolString (appearance == "dark")}
          );

          * {
            font-family: Symbols Nerd Font, ${fontSans};
          }
        '';
      passAsFile = [ "style" ];
    } "sass --no-source-map $stylePath $out";

  swayConfig = {
    modules-left = [
      "sway/workspaces"
      "sway/mode"
      "mpris"
    ];
    modules-center = [ "sway/window" ];
    "sway/workspaces" = {
      format = "{icon}";
      on-click = "activate";
    };
    "sway/mode" = {
      tooltip = false;
    };
    "sway/window" = {
      rewrite = with lib.icons; {
        "^(.*) - Chromium$" = "${chromium} $1";
        "^(.+) - Discord$" = "${discord} $1";
        "^(.+) — Mozilla Firefox$" = "${firefox} $1";
      };
    };
  };
  hyprlandConfig = {
    modules-left = [
      "hyprland/workspaces"
      "mpris"
    ];
    modules-center = [ "hyprland/window" ];
    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "Ⅰ";
        "2" = "Ⅱ";
        "3" = "Ⅲ";
        "4" = "Ⅳ";
        "5" = "Ⅴ";
        "6" = "Ⅵ";
        "7" = "Ⅶ";
        "8" = "Ⅷ";
        "9" = "Ⅸ";
        "10" = "Ⅹ";
      };
    };
  };
  wmSpecific =
    if isSway then
      swayConfig
    else if isHyprland then
      hyprlandConfig
    else
      throw "variable wm-specific not resolved";
in
{
  config = lib.mkIf (isHyprland || isSway) {
    programs.waybar = {
      enable = true;
      settings.main = lib.recursiveUpdate commonSettings wmSpecific;
    };
    wayland.windowManager.sway.config.bars = [
      { command = lib.getExe config.programs.waybar.package; }
    ];
    xdg.configFile = {
      "waybar/style-dark.css".source = buildStyle "dark";
      "waybar/style-light.css".source = buildStyle "light";
    };
  };
}
