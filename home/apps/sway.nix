{
  config,
  flakePath,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  fonts = {
    names = ["IBM Plex Sans" "Symbols Nerd Font"];
    size = 12.0;
  };
  ctp = {
    base = "#1e1e2e";
    crust = "#11111b";
    text = "#cdd6f4";
    pink = "#f5c2e7";
    red = "#f38ba8";
    mauve = "#cba6f7";
  };
in {
  config = lib.mkIf (config.isGraphical && pkgs.stdenv.isLinux && (osConfig.dotfiles.desktop == "sway")) {
    fonts.fontconfig.enable = true;

    home = {
      packages = with pkgs; [
        blueberry
        kooha
        libnotify
        pavucontrol
        sway-contrib.grimshot
        swaynotificationcenter
        swayosd
        wl-clipboard
      ];
    };

    services = {
      clipman.enable = true;
      gnome-keyring = {
        enable = true;
        components = ["secrets"];
      };
      wlsunset = {
        enable = true;
        latitude = toString config.location.latitude;
        longitude = toString config.location.longitude;
      };
      udiskie.enable = true;
    };

    wayland.windowManager.sway = let
      modifier = "Mod4";
    in {
      enable = true;
      package = null;
      config = rec {
        inherit modifier;
        focus.wrapping = "no";
        focus.mouseWarping = "container";
        startup = [
          {
            command = "${pkgs.autotiling}/bin/autotiling -l2";
            always = true;
          }
          {
            command = "1password --silent";
          }
          {
            command = ''
              swayidle -w \
                timeout 180 'swaylock -f' \
                timeout 360 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep 'swaylock -f'
            '';
            always = true;
          }
          {
            command = "${pkgs.swayosd}/bin/swayosd-server";
            always = true;
          }
          {
            command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          }
        ];
        workspaceAutoBackAndForth = true;
        terminal = "${config.programs.wezterm.package}/bin/wezterm";
        menu = "${config.programs.rofi.package}/bin/rofi";
        defaultWorkspace = "workspace number 1";
        input."type:keyboard".xkb_options = "ctrl:nocaps,compose:ralt";
        output."*" = {
          scale = "2";
          bg = "${flakePath}/home/wallpapers/dhm_1610.png fill #171320";
        };
        keybindings = let
          mod = modifier;
          modMove = "${mod}+Shift";
          modFocus = "${mod}+Ctrl";
          hyper = "Mod4+Mod1+Shift+Ctrl";

          filebrowser = "${pkgs.gnome.nautilus}/bin/nautilus";
          screenshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          swayosd = pkgs.swayosd + "/bin/swayosd-client";
        in {
          "${mod}+Shift+b" = "border none";
          "${mod}+b" = "border pixel 2";
          "${mod}+n" = "border normal";
          # reload the configuration file
          "${mod}+Shift+r" = "reload";
          # kill focused window
          "${mod}+Shift+q" = "kill";
          # Start Applications
          "${mod}+Shift+Return" = "exec ${terminal}";
          "${mod}+e" = "exec --no-startup-id ${filebrowser}";
          "${hyper}+p" = "exec --no-startup-id ${screenshot}";

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
          "${mod}+m" = "[class=\"discord\"] scratchpad show";

          # switch to workspace
          "${modFocus}+1" = "workspace 1";
          "${modFocus}+2" = "workspace 2";
          "${modFocus}+3" = "workspace 3";
          "${modFocus}+4" = "workspace 4";
          "${modFocus}+5" = "workspace 5";
          "${modFocus}+6" = "workspace 6";
          "${modFocus}+7" = "workspace 7";
          "${modFocus}+8" = "workspace 8";
          "${modFocus}+9" = "workspace 9";
          "${modFocus}+0" = "workspace 10";
          # Move to workspace with focused container
          "${modMove}+1" = "move container to workspace 1;  workspace 1";
          "${modMove}+2" = "move container to workspace 2;  workspace 2";
          "${modMove}+3" = "move container to workspace 3;  workspace 3";
          "${modMove}+4" = "move container to workspace 4;  workspace 4";
          "${modMove}+5" = "move container to workspace 5;  workspace 5";
          "${modMove}+6" = "move container to workspace 6;  workspace 6";
          "${modMove}+7" = "move container to workspace 7;  workspace 7";
          "${modMove}+8" = "move container to workspace 8;  workspace 8";
          "${modMove}+9" = "move container to workspace 9;  workspace 9";
          "${modMove}+0" = "move container to workspace 10; workspace 10";
          # rofi instead of drun
          "${mod}+space" = "exec --no-startup-id ${menu} -show drun -dpi $dpi";
          # 1password
          "${mod}+Shift+space" = "exec ${pkgs._1password-gui}/bin/1password --quick-access";

          # audio
          "XF86AudioRaiseVolume" = "exec ${swayosd} --output-volume 5";
          "XF86AudioLowerVolume" = "exec ${swayosd} --output-volume -5";
          "XF86AudioMute" = "exec ${swayosd} --output-volume mute-toggle";
          "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
          "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
          "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";

          # modes
          "${mod}+r" = "mode \"resize\"";
          "${mod}+p" = "mode \"power: (l)ock, (e)xit, (r)eboot, (s)uspend, (h)ibernate, (S)hut off\"";
        };
        modes = {
          "power: (l)ock, (e)xit, (r)eboot, (s)uspend, (h)ibernate, (S)hut off" = {
            l = "exec --no-startup-id swaylock --color 000000, mode \"default\"";
            e = "exec --no-startup-id swaymsg exit, mode \"default\"";
            r = "exec --no-startup-id systemctl reboot, mode \"default\"";
            s = "exec --no-startup-id systemctl suspend, mode \"default\"";
            h = "exec --no-startup-id systemctl hibernate, mode \"default\"";
            "Shift+s" = "exec --no-startup-id systemctl poweroff, mode \"default\"";
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
        inherit fonts;
        colors = rec {
          focused = {
            background = ctp.base;
            border = ctp.pink;
            childBorder = ctp.pink;
            indicator = ctp.pink;
            inherit (ctp) text;
          };
          urgent = {
            background = ctp.base;
            border = ctp.red;
            childBorder = ctp.red;
            indicator = ctp.red;
            inherit (ctp) text;
          };
          unfocused = {
            background = ctp.base;
            border = ctp.mauve;
            childBorder = ctp.mauve;
            indicator = ctp.mauve;
            inherit (ctp) text;
          };
          focusedInactive = unfocused;
          placeholder = unfocused;
        };
        window = {
          titlebar = false;
          hideEdgeBorders = "none";
          border = 2;
        };
        gaps = {
          inner = 5;
          outer = 2;
        };
        bars = [
          {
            inherit fonts;
            mode = "hide";
            position = "top";
            statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          }
        ];
      };

      extraConfig = ''
        for_window [floating] border pixel 2

        # floating sticky
        for_window [class="1Password"] floating enable sticky enable
        for_window [window_role="PictureInPicture"] floating enable sticky enable

        # floating
        for_window [class="GParted"] floating enable
        for_window [title="(?i)SteamTinkerLaunch"] floating enable
        for_window [title="Blender Render"] floating enable

        # general WM role settings
        for_window [title="splash"] floating enable
        for_window [urgent=latest] focus
        for_window [window_role="pop-up"] floating enable
        for_window [window_role="task_dialog"] floating enable

        # apps
        for_window [class="Pavucontrol"] floating enable
        for_window [class="Yad" title="Authentication"] floating enable
        for_window [class="jetbrains*" title="Welcome*"] floating enable
        for_window [title="File Transfer*"] floating enable
        for_window [title="Steam Guard*"] floating enable

        # keep apps in scratchpad
        for_window [class="discord"] move scratchpad sticky

        set $mode_gaps Gaps: (o)uter, (i)nner
        set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
        set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
        bindsym ${modifier}+Shift+g mode "$mode_gaps"

        mode "$mode_gaps" {
          bindsym o      mode "$mode_gaps_outer"
          bindsym i      mode "$mode_gaps_inner"
          bindsym Return mode "$mode_gaps"
          bindsym Escape mode "default"
        }
        mode "$mode_gaps_outer" {
          bindsym plus  gaps outer current plus 5
          bindsym minus gaps outer current minus 5
          bindsym 0     gaps outer current set 0

          bindsym Shift+plus  gaps outer all plus 5
          bindsym Shift+minus gaps outer all minus 5
          bindsym Shift+0     gaps outer all set 0

          bindsym Return mode "$mode_gaps"
          bindsym Escape mode "default"
        }
        mode "$mode_gaps_inner" {
          bindsym plus  gaps inner current plus 5
          bindsym minus gaps inner current minus 5
          bindsym 0     gaps inner current set 0

          bindsym Shift+plus  gaps inner all plus 5
          bindsym Shift+minus gaps inner all minus 5
          bindsym Shift+0     gaps inner all set 0

          bindsym Return mode "$mode_gaps"
          bindsym Escape mode "default"
        }

        shadows             enable
        shadow_color        #11111b99
        shadow_blur_radius  20

        corner_radius       5
        smart_corner_radius enable

        blur                enable
        blur_passes         2
        blur_radius         4

        layer_effects       "swaync-notification-window" blur enable; shadows enable; corner_radius 5;
      '';
      systemd = {
        enable = true;
        xdgAutostart = true;
      };
    };
  };
}
