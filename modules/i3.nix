{
  config,
  lib,
  flakePath,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  home = lib.mkIf isLinux {
    packages = with pkgs; [
      arandr
      blueberry
      libnotify
      pavucontrol
      xclip
      xdotool
    ];
  };

  programs = lib.mkIf isLinux {
    i3status-rust = {
      enable = true;
      bars.default = {
        blocks = [
          {
            block = "taskwarrior";
            data_location = config.programs.taskwarrior.dataLocation;
          }
          {
            block = "pomodoro";
            notifier = "notifysend";
            notifier_path = "${lib.getExe pkgs.libnotify}";
          }
          {
            block = "sound";
            max_vol = 100;
            on_click = "${lib.getExe pkgs.pavucontrol}";
          }
          {
            block = "time";
            interval = 5;
            format = "%R";
          }
        ];
        settings = {
          icons.name = "material-nf";
          icons.overrides = {
            pomodoro = " ";
            pomodoro_break = " ";
          };
          theme.overrides = {
            idle_fg = "#cdd6f4";
            info_fg = "#89b4fa";
            good_fg = "#a6e3a1";
            warning_fg = "#fab387";
            critical_fg = "#f38ba8";
            separator = " ";
            separator_bg = "auto";
            separator_fg = "auto";
          };
        };
      };
    };
  };

  services = lib.mkIf isLinux {
    dunst.enable = true;
    flameshot = {
      enable = true;
      settings.General.showStartupLaunchMessage = false;
    };
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    picom = let
      riced = true;
    in {
      enable = true;
      fade = true;
      backend = "glx";
      vSync = true;
      shadow = riced;
      settings = {
        animations = true;
        animation-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];

        animation-for-open-window = "zoom";
        animation-for-unmap-window = "zoom";

        animation-for-prev-tag = "zoom";
        animation-for-next-tag = "zoom";

        enable-fading-prev-tag = true;
        enable-fading-next-tag = true;

        blur = lib.mkIf riced {
          method = "dual_kawase";
        };
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_NET_WM_NAME@:s *?= 'Discover Voice'"
          "_NET_WM_NAME@:s *?= 'Discover Text'"
        ];
      };
    };
    redshift = {
      enable = true;
      latitude = 48.2;
      longitude = 16.366667;
    };
    screen-locker = {
      enable = true;
      inactiveInterval = 5;
      lockCmd = "${lib.getExe pkgs.i3lock} -n -c 000000";
    };
    udiskie.enable = true;
  };

  # https://github.com/nix-community/home-manager/issues/2064
  # systemd = lib.mkIf isLinux {
  #   user.targets.tray.Unit = {
  #     Description = "Home Manager System Tray";
  #     Requires = ["graphical-session-pre.target"];
  #   };
  # };

  xsession = lib.mkIf isLinux {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        focus.wrapping = "no";
        startup = [
          {
            command = "${lib.getExe pkgs.autotiling}";
            notification = false;
          }
          {
            command = "${lib.getExe pkgs._1password-gui} --silent";
            notification = false;
          }
        ];
        workspaceAutoBackAndForth = true;
        terminal = "${lib.getExe pkgs.unstable.wezterm} start --always-new-process";
        menu = "";
        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
          modMove = "${mod}+Shift";
          modFocus = "${mod}+Ctrl";
          hyper = "Mod4+Mod1+Shift+Ctrl";
        in {
          "${mod}+Shift+b" = "border none";
          "${mod}+b" = "border pixel 2";
          "${mod}+n" = "border normal";
          # reload the configuration file
          "${mod}+Shift+c" = "reload";
          # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
          "${mod}+Shift+r" = "restart";
          # kill focused window
          "${mod}+Shift+q" = "kill";
          # Start Applications
          "${mod}+Shift+Return" = "exec ${config.xsession.windowManager.i3.config.terminal}";
          "${mod}+e" = "exec --no-startup-id $fileman";
          "${mod}+Ctrl+x" = "exec --no-startup-id ${lib.getExe pkgs.xorg.xkill}";
          "${hyper}+p" = "--release exec --no-startup-id ${lib.getExe pkgs.flameshot} gui";
          # TODO: yeah no
          # "${hyper}+space" = "exec --no-startup-id gopass ls --flat | rofi -dmenu -dpi $dpi | xargs --no-run-if-empty gopass show -o | xdotool type --clearmodifiers --file -";

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
          "${modFocus}+1" = "workspace $ws1";
          "${modFocus}+2" = "workspace $ws2";
          "${modFocus}+3" = "workspace $ws3";
          "${modFocus}+4" = "workspace $ws4";
          "${modFocus}+5" = "workspace $ws5";
          "${modFocus}+6" = "workspace $ws6";
          "${modFocus}+7" = "workspace $ws7";
          "${modFocus}+8" = "workspace $ws8";
          "${modFocus}+9" = "workspace $ws9";
          "${modFocus}+0" = "workspace $ws10";
          # Move to workspace with focused container
          "${modMove}+1" = "move container to workspace $ws1;  workspace $ws1";
          "${modMove}+2" = "move container to workspace $ws2;  workspace $ws2";
          "${modMove}+3" = "move container to workspace $ws3;  workspace $ws3";
          "${modMove}+4" = "move container to workspace $ws4;  workspace $ws4";
          "${modMove}+5" = "move container to workspace $ws5;  workspace $ws5";
          "${modMove}+6" = "move container to workspace $ws6;  workspace $ws6";
          "${modMove}+7" = "move container to workspace $ws7;  workspace $ws7";
          "${modMove}+8" = "move container to workspace $ws8;  workspace $ws8";
          "${modMove}+9" = "move container to workspace $ws9;  workspace $ws9";
          "${modMove}+0" = "move container to workspace $ws10; workspace $ws10";
          # rofi instead of drun
          "${mod}+space" = "exec --no-startup-id ${lib.getExe pkgs.rofi-wayland} -show drun -dpi $dpi";
          # 1password
          "${mod}+Shift+space" = "exec ${lib.getExe pkgs._1password-gui} --quick-access";

          # audio
          "XF86AudioRaiseVolume" = "--no-startup-id pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "--no-startup-id pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
          "XF86AudioNext" = "exec --no-startup-id playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
          "XF86AudioPause" = "exec --no-startup-id playerctl play-pause";

          # modes
          "${mod}+r" = "mode \"resize\"";
          "${mod}+p" = "mode \"system\"";
        };
        modes = {
          system = {
            "l" = "exec --no-startup-id i3exit lock, mode \"default\"";
            "s" = "exec --no-startup-id i3exit suspend, mode \"default\"";
            "u" = "exec --no-startup-id i3exit switch_user, mode \"default\"";
            "e" = "exec --no-startup-id i3exit logout, mode \"default\"";
            "h" = "exec --no-startup-id i3exit hibernate, mode \"default\"";
            "r" = "exec --no-startup-id i3exit reboot, mode \"default\"";
            "Shift+s" = "exec --no-startup-id i3exit shutdown, mode \"default\"";
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
          names = ["Berkeley Mono"];
          size = 16.0;
        };
        bars = [
          {
            mode = "hide";
            hiddenState = "hide";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
            position = "top";
            colors = {
              background = "#000000";
            };
          }
        ];
        colors = let
          unfocused = {
            background = "#000000";
            border = "#CBA6F7";
            childBorder = "#CBA6F7";
            text = "#CDD6F4";
            indicator = "#CBA6F7";
          };
        in {
          focused = {
            background = "#000000";
            border = "#F5C2E7";
            childBorder = "#F5C2E7";
            text = "#CDD6F4";
            indicator = "#F5C2E7";
          };
          urgent = {
            background = "#000000";
            border = "#F38BA8";
            childBorder = "#F38BA8";
            text = "#CDD6F4";
            indicator = "#F38BA8";
          };
          focusedInactive = unfocused;
          unfocused = unfocused;
          placeholder = unfocused;
        };
        window = {
          titlebar = false;
          hideEdgeBorders = "none";
          border = 2;
        };
      };
      extraConfig = ''
        set_from_resource $dpi Xft.dpi 140
        title_align center
        set $ws1  1:Ⅰ
        set $ws2  2:Ⅱ
        set $ws3  3:Ⅲ
        set $ws4  4:Ⅳ
        set $ws5  5:Ⅴ
        set $ws6  6:Ⅵ
        set $ws7  7:Ⅶ
        set $ws8  8:Ⅷ
        set $ws9  9:Ⅸ
        set $ws10 10:Ⅹ

        # manage window rules
        for_window [urgent=latest] focus

        # floating sticky
        for_window [class="Lxappearance"]                floating enable sticky enable border normal
        for_window [class="Qtconfig-qt4"]                floating enable sticky enable border normal
        for_window [class="qt5ct"]                       floating enable sticky enable border normal

        for_window [class="1Password"]                   floating enable sticky enable border pixel 1
        for_window [title="Blender Render"]              floating enable border pixel 1
        for_window [title="(?i)SteamTinkerLaunch"]       floating enable border pixel 1

        # floating with normal border (titled)
        for_window [class="(?i)virtualbox"]              floating enable border normal
        for_window [class="GParted"]                     floating enable border normal

        # floating without special settings

        # general WM role settings
        for_window [window_role="pop-up"]                floating enable
        for_window [window_role="task_dialog"]           floating enable
        for_window [title="splash"]                      floating enable

        # apps
        for_window [class="Lightdm-settings"]            floating enable
        for_window [class="Pavucontrol"]                 floating enable
        for_window [title="File Transfer*"]              floating enable
        for_window [title="Steam Guard*"]                floating enable
        for_window [class="Yad" title="Authentication"]  floating enable
        for_window [class="jetbrains*" title="Welcome*"] floating enable

        # keep apps in scratchpad
        for_window [class="discord"]                     move scratchpad
      '';
    };
  };

  # xdg = lib.mkIf isLinux {
  #   configFile."i3" = {
  #     source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/i3";
  #     recursive = true;
  #   };
  # };
}
