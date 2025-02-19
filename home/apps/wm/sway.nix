{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  isSway = (
    builtins.elem osConfig.dotfiles.desktop [
      "sway"
      "swayfx"
    ]
  );
  isSwayFx = osConfig.dotfiles.desktop == "swayfx";

  inherit (config.fonts.fontconfig) defaultFonts;
  fontSans = builtins.head defaultFonts.sansSerif;

  inherit (lib) milspec;

  mod = "Mod4";
  modMove = "${mod}+Shift";
  modFocus = "${mod}+Ctrl";
  hyper = "Mod4+Mod1+Shift+Ctrl";

  filebrowser = "${lib.getExe pkgs.nautilus} -w";
  playerctl = lib.getExe pkgs.playerctl;
  screenshot = "${lib.getExe pkgs.sway-contrib.grimshot} copy area";
  swayosd-client = "${config.services.swayosd.package}/bin/swayosd-client";

  cfg = config.wayland.windowManager.sway.config;

  mkColors' =
    fg: bg: accent:
    "${accent} ${bg} ${fg} ${accent} ${accent}";
  mkColors =
    colors: with colors; [
      "client.focused          ${mkColors' fg core rose}"
      "client.focused_inactive ${mkColors' fg core indigo}"
      "client.unfocused        ${mkColors' fg core gray}"
      "client.urgent           ${mkColors' fg core red}"
    ];
  mkSwayMsgs = colors: lib.concatLines (builtins.map (msg: "swaymsg '${msg}'") (mkColors colors));
in
{
  wayland.windowManager.sway = {
    enable = isSway;
    package = null;
    config = {
      modifier = mod;
      focus = {
        wrapping = "no";
        mouseWarping = "container";
      };
      startup = [ { command = "1password --silent"; } ];
      workspaceAutoBackAndForth = true;
      terminal = lib.getExe config.programs.ghostty.package;
      menu = "${lib.getExe config.programs.rofi.package} -show drun -dpi $dpi";
      defaultWorkspace = "workspace number 1";
      input."type:keyboard".xkb_options = "ctrl:nocaps,compose:ralt";
      output."*" = {
        scale = "2";
        bg = "${../../wallpapers/dhm_1610.png} fill #171320";
      };
      keybindings = {
        "${mod}+Shift+b" = "border none";
        "${mod}+b" = "border pixel 2";
        "${mod}+n" = "border normal";
        # reload the configuration file
        "${mod}+Shift+r" = "reload";
        # kill focused window
        "${mod}+Shift+q" = "kill";
        # Start Applications
        "${mod}+Shift+Return" = "exec ${cfg.terminal}";
        "${mod}+e" = "exec ${filebrowser}";
        "${hyper}+p" = "exec ${screenshot}";

        # change focus
        "${modFocus}+h" = "focus left";
        "${modFocus}+j" = "focus down";
        "${modFocus}+k" = "focus up";
        "${modFocus}+l" = "focus right";
        "${modFocus}+Left" = "focus left";
        "${modFocus}+Down" = "focus down";
        "${modFocus}+Up" = "focus up";
        "${modFocus}+Right" = "focus right";
        # move focus
        "${modMove}+h" = "move left";
        "${modMove}+j" = "move down";
        "${modMove}+k" = "move up";
        "${modMove}+l" = "move right";
        "${modMove}+Left" = "move left";
        "${modMove}+Down" = "move down";
        "${modMove}+Up" = "move up";
        "${modMove}+Right" = "move right";

        # move workspaces across monitors
        "${modMove}+greater" = "move workspace to output right";
        "${modMove}+less" = "move workspace to output left";

        # split orientation
        "${mod}+q" = "split toggle";

        # toggle fullscreen mode for the focused container
        "${mod}+f" = "fullscreen toggle";

        # change container layout (stacked, tabbed, toggle split)
        "${mod}+s" = "layout toggle";

        # toggle tiling / floating
        "${mod}+Shift+d" = "floating toggle";
        # change focus between tiling / floating windows
        "${mod}+d" = "focus mode_toggle";

        # toggle sticky
        "${mod}+Shift+s" = "sticky toggle";

        # focus the parent container
        "${mod}+a" = "focus parent";

        # move the currently focused window to the scratchpad
        "${mod}+Shift+Tab" = "move scratchpad";
        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${mod}+Tab" = "scratchpad show";
        "${mod}+m" = "[app_id='discord'] scratchpad show";

        # switch to workspace
        "${modFocus}+1" = "workspace number 1";
        "${modFocus}+2" = "workspace number 2";
        "${modFocus}+3" = "workspace number 3";
        "${modFocus}+4" = "workspace number 4";
        "${modFocus}+5" = "workspace number 5";
        "${modFocus}+6" = "workspace number 6";
        "${modFocus}+7" = "workspace number 7";
        "${modFocus}+8" = "workspace number 8";
        "${modFocus}+9" = "workspace number 9";
        "${modFocus}+0" = "workspace number 10";
        # Move to workspace with focused container
        "${modMove}+1" = "move container to workspace number 1;  workspace number 1";
        "${modMove}+2" = "move container to workspace number 2;  workspace number 2";
        "${modMove}+3" = "move container to workspace number 3;  workspace number 3";
        "${modMove}+4" = "move container to workspace number 4;  workspace number 4";
        "${modMove}+5" = "move container to workspace number 5;  workspace number 5";
        "${modMove}+6" = "move container to workspace number 6;  workspace number 6";
        "${modMove}+7" = "move container to workspace number 7;  workspace number 7";
        "${modMove}+8" = "move container to workspace number 8;  workspace number 8";
        "${modMove}+9" = "move container to workspace number 9;  workspace number 9";
        "${modMove}+0" = "move container to workspace number 10; workspace number 10";
        # rofi instead of drun
        "${mod}+space" = "exec ${cfg.menu}";
        # 1password
        "${mod}+Shift+space" = "exec 1password --quick-access";

        # audio
        "XF86AudioRaiseVolume" = "exec ${swayosd-client} --output-volume 5";
        "XF86AudioLowerVolume" = "exec ${swayosd-client} --output-volume -5";
        "XF86AudioMute" = "exec ${swayosd-client} --output-volume mute-toggle";
        "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
        "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
        "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";

        # modes
        "${mod}+r" = "mode resize";
        "${mod}+p" = "mode 'power: (l)ock, (e)xit, (r)eboot, (s)uspend, (S)hut off'";
      };
      modes = {
        "power: (l)ock, (e)xit, (r)eboot, (s)uspend, (S)hut off" = {
          l = "exec --no-startup-id swaylock; mode default";
          e = "exec --no-startup-id swaymsg exit; mode default";
          r = "exec --no-startup-id systemctl reboot; mode default";
          s = "exec --no-startup-id systemctl sleep; mode default";
          "Shift+s" = "exec --no-startup-id systemctl poweroff; mode default";
          Escape = "mode default";
          Return = "mode default";
        };
        resize = {
          Escape = "mode default";
          Return = "mode default";
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          R = "resize set 50 ppt 50 ppt";
        };
      };
      fonts = {
        names = [
          fontSans
          "Symbols Nerd Font"
        ];
        size = 12.0;
      };
      window = {
        border = 2;
        hideEdgeBorders = "both";
        titlebar = false;
      };
      floating = {
        border = 2;
        titlebar = false;
      };
      gaps = lib.mkIf isSwayFx {
        inner = 5;
        outer = 2;
      };
    };

    extraConfig =
      ''
        for_window {
          # fullscreen apps inhibit idle
          [class=".*"] inhibit_idle fullscreen

          # floating sticky
          [class="1Password"] floating enable; sticky enable; border pixel 2
          [title="(?i)picture[\s-]?in[\s-]?picture"] floating enable; sticky enable; border pixel 2

          # floating
          [title="Blender Render"] floating enable; border pixel 2

          # general WM role settings
          [title="splash"] floating enable; border pixel 2
          [urgent=latest] focus
          [window_role="pop-up,dialog,task_dialog,About"] floating enable; border pixel 2
          [window_type="dialog"] floating enable; border pixel 2
          [window_type="utility"] floating enable; border pixel 2
          [window_type="toolbar"] floating enable; border pixel 2
          [window_type="splash"] floating enable; border pixel 2
          [window_type="menu"] floating enable; border pixel 2
          [window_type="dropdown_menu"] floating enable; border pixel 2
          [window_type="popup_menu"] floating enable; border pixel 2
          [window_type="tooltip"] floating enable; border pixel 2
          [window_type="notification"] floating enable; border pixel 2

          [app_id="jetbrains*" title="Welcome*"] floating enable; border pixel 2
          [class="jetbrains*" title="Welcome*"] floating enable; border pixel 2

          [app_id="org.gnome.NautilusPreviewer"] floating enable; border pixel 2
          [app_id="swaysettings"] floating enable; border pixel 2
          [class="Yad" title="Authentication"] floating enable; border pixel 2
          [title="File Transfer*"] floating enable; border pixel 2

          # steam
          [class="steam"] max_render_time off
          [instance="steamwebhelper"] max_render_time off
          [title="Steam Guard*"] floating enable; border pixel 2

          # keep apps in scratchpad
          [app_id="discord"] move scratchpad
        }

        set {
          $mode_gaps       "Gaps: (o)uter, (i)nner"
          $mode_gaps_outer "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)"
          $mode_gaps_inner "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)"
        }
        bindsym ${mod}+Shift+g mode $mode_gaps

        mode $mode_gaps bindsym {
          o      mode $mode_gaps_outer
          i      mode $mode_gaps_inner
          Return mode $mode_gaps
          Escape mode default
        }
        mode $mode_gaps_outer bindsym {
          plus        gaps outer current plus 5
          minus       gaps outer current minus 5
          0           gaps outer current set 0

          Shift+plus  gaps outer all     plus 5
          Shift+minus gaps outer all     minus 5
          Shift+0     gaps outer all     set 0

          Return mode $mode_gaps
          Escape mode default
        }
        mode $mode_gaps_inner bindsym {
          plus        gaps inner current plus 5
          minus       gaps inner current minus 5
          0           gaps inner current set 0

          Shift+plus  gaps inner all     plus 5
          Shift+minus gaps inner all     minus 5
          Shift+0     gaps inner all     set 0

          Return mode $mode_gaps
          Escape mode default
        }
      ''
      + lib.concatLines (mkColors milspec.dark)
      + lib.optionalString isSwayFx ''
        shadows             enable
        shadow_color        #11111b99
        shadow_blur_radius  20

        corner_radius       5
        smart_corner_radius enable

        blur                enable
        blur_passes         2
        blur_radius         4
      '';
    systemd = {
      enable = true;
      xdgAutostart = true;
      variables = [
        "DISPLAY"
        "WAYLAND_DISPLAY"
        "SWAYSOCK"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "NIXOS_OZONE_WL"
        "XCURSOR_THEME"
        "XCURSOR_SIZE"
        "PATH"
      ];
    };
  };

  services.darkman = lib.mkIf isSway {
    darkModeScripts.sway = mkSwayMsgs milspec.dark;
    lightModeScripts.sway = mkSwayMsgs milspec.light;
  };

  systemd.user.services = lib.mkIf isSway {
    autotiling = {
      Unit = {
        Description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.autotiling} -l2";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
