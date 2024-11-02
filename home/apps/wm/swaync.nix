{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isWindowManager =
    config.wayland.windowManager.hyprland.enable || config.wayland.windowManager.sway.enable;

  isSwayFx = osConfig.dotfiles.desktop == "swayfx";

  inherit (config.fonts.fontconfig) defaultFonts;
  fontSans = builtins.head defaultFonts.sansSerif;

  boolString = cond: if cond then "true" else "false";
  buildStyle =
    appearance:
    pkgs.runCommandNoCC "hm_swayncstyle${appearance}.css" {
      nativeBuildInputs = [ pkgs.dart-sass ];
      style = # scss
        ''
          @use "${./scss}/swaync";

          @include swaync.main(
            $fancy: ${boolString isSwayFx},
            $dark: ${boolString (appearance == "dark")}
          );

          * {
            font-family: Symbols Nerd Font, ${fontSans};
          }
        '';
      passAsFile = [ "style" ];
    } "sass --no-source-map $stylePath $out";
in
{
  config = lib.mkIf isWindowManager {
    services.swaync = {
      enable = true;
      settings = {
        control-center-layer = "top";
        control-center-margin-bottom = 0;
        control-center-margin-left = 0;
        control-center-margin-right = 0;
        control-center-margin-top = 0;
        control-center-width = 500;
        cssPriority = "application";
        fit-to-screen = true;
        hide-on-action = true;
        hide-on-clear = false;
        image-visibility = "when-available";
        keyboard-shortcuts = true;
        layer = "overlay";
        layer-shell = true;
        notification-2fa-action = true;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-icon-size = 64;
        notification-inline-replies = false;
        notification-visibility = { };
        notification-window-width = 500;
        positionX = "right";
        positionY = "top";
        relative-timestamps = true;
        script-fail-notify = true;
        scripts = { };
        timeout = 10;
        timeout-critical = 0;
        timeout-low = 5;
        transition-time = 200;
        widget-config = {
          title = {
            button-text = "Clear All";
            clear-all-button = true;
            text = "Notifications";
          };
          dnd.text = "Do Not Disturb";
          menubar = {
            buttons = {
              actions = [
                {
                  active = true;
                  command = "darkman toggle";
                  label = "󰔎 Toggle Appearance";
                  type = "toggle";
                }
              ];
              position = "left";
            };
            menu = {
              actions = [
                {
                  active = true;
                  command = "swaylock";
                  label = "󰌾 Lock";
                }
                {
                  active = true;
                  command = "systemctl sleep";
                  label = "󰤄 Sleep";
                }
                {
                  active = true;
                  command = "systemctl poweroff";
                  label = "󰐥 Shut down";
                }
                {
                  active = true;
                  command = "systemctl reboot";
                  label = "󰜉 Restart";
                }
              ];
              animation-duration = 250;
              animation-type = "slide_down";
              label = "󰐥 Power";
              position = "right";
            };
          };
          mpris = {
            image-radius = 12;
            image-size = 96;
          };
          volume = {
            collapse-button-label = "";
            expand-button-label = "";
            label = "Volume";
            show-per-app = true;
            show-per-app-icon = false;
            show-per-app-label = true;
          };
        };
        widgets = [
          "title"
          "dnd"
          "menubar"
          "notifications"
          "mpris"
          "volume"
        ];
      };
    };

    programs.waybar.settings.main = {
      "custom/swaync" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
    };

    services.darkman = {
      darkModeScripts.swaync = # bash
        ''
          ln -sf ${buildStyle "dark"} ~/.config/swaync/style.css
          swaync-client --reload-css
        '';
      lightModeScripts.swaync = # bash
        ''
          ln -sf ${buildStyle "light"} ~/.config/swaync/style.css
          swaync-client --reload-css
        '';
    };
  };
}
