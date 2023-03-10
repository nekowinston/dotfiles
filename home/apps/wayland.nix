{
  config,
  flakePath,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  waybarLauncher = pkgs.writeShellScriptBin "waybar-launcher" (let
    killall = lib.getExe pkgs.killall;
    inotifywait = pkgs.inotify-tools + "/bin/inotifywait";
  in ''
    #!/bin/sh
    trap "${killall} .waybar-wrapped" EXIT
    while true; do
    	waybar &
    	${inotifywait} -e create,modify "$HOME/.config/waybar/config" "$HOME/.config/waybar/style.css"
    	${killall} .waybar-wrapped
    done
  '');
in {
  programs.waybar = lib.mkIf isLinux {
    enable = true;
    package = pkgs.waybar-hyprland;
  };

  xdg = lib.mkIf isLinux {
    configFile."waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/waybar";
      recursive = true;
    };

    configFile."hypr/hyprland.conf".text = let
      playerctl = lib.getExe pkgs.playerctl;
      wpctl = pkgs.wireplumber + "/bin/wpctl";
    in ''
      monitor = ,5120x2160@72,0x0,2.0

      input:follow_mouse = 1

      general {
        gaps_in = 5
        gaps_out = 5
        border_size = 2
        no_cursor_warps = true
        col.active_border = 0xfff5c2e7
        col.inactive_border = 0x80cba6f7
      }

      decoration {
        rounding = 5
        blur = 0
      }

      animations {
        enabled = 1
        animation = workspaces,1,1,default,slide
      }

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      bind = SUPER_SHIFT,return,exec,wezterm
      bind = SUPER_SHIFT,q,killactive,
      bind = SUPER_SHIFT,M,exit,
      bind = SUPER_SHIFT,d,togglefloating,
      bind = SUPER,space,exec,rofi -show drun

      bind = SUPER_CTRL,l,movefocus,l
      bind = SUPER_CTRL,h,movefocus,r
      bind = SUPER_CTRL,k,movefocus,u
      bind = SUPER_CTRL,j,movefocus,d
      bind = SUPER_SHIFT,h,movewindow,l
      bind = SUPER_SHIFT,l,movewindow,r
      bind = SUPER_SHIFT,j,movewindow,u
      bind = SUPER_SHIFT,k,movewindow,d

      bind = SUPER_CTRL,1,workspace,1
      bind = SUPER_CTRL,2,workspace,2
      bind = SUPER_CTRL,3,workspace,3
      bind = SUPER_CTRL,4,workspace,4
      bind = SUPER_CTRL,5,workspace,5
      bind = SUPER_CTRL,6,workspace,6
      bind = SUPER_CTRL,7,workspace,7
      bind = SUPER_CTRL,8,workspace,8
      bind = SUPER_CTRL,9,workspace,9
      bind = SUPER_CTRL,0,workspace,10

      bind = SUPER_SHIFT,1,movetoworkspace,1
      bind = SUPER_SHIFT,2,movetoworkspace,2
      bind = SUPER_SHIFT,3,movetoworkspace,3
      bind = SUPER_SHIFT,4,movetoworkspace,4
      bind = SUPER_SHIFT,5,movetoworkspace,5
      bind = SUPER_SHIFT,6,movetoworkspace,6
      bind = SUPER_SHIFT,7,movetoworkspace,7
      bind = SUPER_SHIFT,8,movetoworkspace,8
      bind = SUPER_SHIFT,9,movetoworkspace,9
      bind = SUPER_SHIFT,0,movetoworkspace,10

      bindm = SUPER,mouse:272,movewindow
      bindm = SUPER,mouse:273,resizewindow

      binde = ,XF86AudioRaiseVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
      binde = ,XF86AudioLowerVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0
      bind = ,XF86AudioMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = ,XF86AudioNext,exec,${playerctl} next
      bind = ,XF86AudioPrev,exec,${playerctl} previous
      bind = ,XF86AudioPause,exec,${playerctl} play-pause
      exec-once = ${waybarLauncher}/bin/waybar-launcher

      # sets xwayland scale
      exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

      # toolkit-specific scale
      env = GDK_SCALE,2
      env = XCURSOR_SIZE,32
    '';
  };
}
