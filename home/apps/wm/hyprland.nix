{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  config = lib.mkIf (osConfig.dotfiles.desktop == "hyprland") {
    home = {
      packages = with pkgs; [
        swaybg
      ];
    };

    wayland.windowManager.hyprland =
      let
        mod = "SUPER";
        modFocus = "${mod}_CTRL";
        modMove = "${mod}_SHIFT";
        hyper = "SUPER_CTRL_SHIFT_ALT";
        swayosd = pkgs.swayosd + "/bin/swayosd-client";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in
      {
        enable = true;
        settings = {
          monitor = ",preferred,auto,2";
          input.follow_mouse = 1;
          env = [
            "MOZ_ENABLE_WAYLAND, 1"
            "NIXOS_OZONE_WL, 1"
            "QT_QPA_PLATFORM, wayland"
            "SDL_VIDEODRIVER, wayland"
            "GDK_SCALE, 2"
            "XCURSOR_SIZE, 24"
            "XDG_CURRENT_DESKTOP, hyprland"
            "XDG_SESSION_DESKTOP, hyprland"
            "XDG_SESSION_TYPE, wayland"
            "_JAVA_AWT_WM_NONREPARENTING, 1"
          ];
          xwayland.force_zero_scaling = true;
          general = {
            gaps_in = 2;
            gaps_out = 5;
            border_size = 2;
            "col.active_border" = "0xfff5c2e7";
            "col.inactive_border" = "0x80cba6f7";
          };
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };
          decoration.rounding = 5;
          dwindle.preserve_split = true;
          windowrulev2 = [ "suppressevent maximize, class:.*" ];
          bind = [
            "${modMove}, return, exec, kitty"
            "${modMove}, q, killactive,"
            "${modMove}, m, exit,"
            "${modMove}, d, togglefloating,"
            "${mod}, space, exec, rofi -show drun"
            "${modMove}, space, exec, 1password --quick-access"
            "${hyper}, p, exec, grimblast --notify --freeze copy area"
            "${modMove}, p, exec, hyprpicker -a"

            "${modFocus}, h, movefocus, l"
            "${modFocus}, j, movefocus, d"
            "${modFocus}, k, movefocus, u"
            "${modFocus}, l, movefocus, r"
            "${modMove}, h, movewindow, l"
            "${modMove}, j, movewindow, u"
            "${modMove}, k, movewindow, d"
            "${modMove}, l, movewindow, r"

            "${modFocus}, 1, workspace, 1"
            "${modFocus}, 2, workspace, 2"
            "${modFocus}, 3, workspace, 3"
            "${modFocus}, 4, workspace, 4"
            "${modFocus}, 5, workspace, 5"
            "${modFocus}, 6, workspace, 6"
            "${modFocus}, 7, workspace, 7"
            "${modFocus}, 8, workspace, 8"
            "${modFocus}, 9, workspace, 9"
            "${modFocus}, 0, workspace, 10"

            "${modMove}, 1, movetoworkspace, 1"
            "${modMove}, 2, movetoworkspace, 2"
            "${modMove}, 3, movetoworkspace, 3"
            "${modMove}, 4, movetoworkspace, 4"
            "${modMove}, 5, movetoworkspace, 5"
            "${modMove}, 6, movetoworkspace, 6"
            "${modMove}, 7, movetoworkspace, 7"
            "${modMove}, 8, movetoworkspace, 8"
            "${modMove}, 9, movetoworkspace, 9"
            "${modMove}, 0, movetoworkspace, 10"
            "${mod}, tab, togglespecialworkspace, magic"
            "${modMove}, tab, movetoworkspace, special:magic"

            ", XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
            ", XF86AudioNext, exec, ${playerctl} next"
            ", XF86AudioPrev, exec, ${playerctl} previous"
            ", XF86AudioPause, exec, ${playerctl} play-pause"
          ];
          binde = [
            ", XF86AudioRaiseVolume, exec, ${swayosd} --output-volume 5"
            ", XF86AudioLowerVolume, exec, ${swayosd} --output-volume -5"
          ];
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          exec = [
            "${pkgs.swaybg}/bin/swaybg -o '*' -m fill -i ${../../wallpapers/dhm_1610.png}"
          ];
          exec-once = [ "${config.programs.waybar.package}/bin/waybar -b hyprland" ];
          plugin.hy3.autotile.enable = true;
        };
        plugins = [ pkgs.hyprlandPlugins.hy3 ];
      };
  };
}
