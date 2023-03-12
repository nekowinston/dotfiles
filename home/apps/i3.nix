{
  config,
  lib,
  flakePath,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  fonts = {
    names = ["IBM Plex Sans" "Symbols Nerd Font"];
    size = 16.0;
  };

  commonConfig = {wayland ? false}: rec {
    modifier = "Mod4";
    focus.wrapping = "no";
    startup = [
      {
        command = "${lib.getExe pkgs.autotiling} -l2";
        always = true;
      }
      {
        command = "${lib.getExe pkgs._1password-gui} --silent";
      }
    ];
    workspaceAutoBackAndForth = true;
    terminal = "wezterm start --always-new-process";
    menu = "";
    keybindings = let
      mod = modifier;
      modMove = "${mod}+Shift";
      modFocus = "${mod}+Ctrl";
      hyper = "Mod4+Mod1+Shift+Ctrl";

      gopass = lib.getExe pkgs.unstable.gopass;
      rofi = lib.getExe config.programs.rofi.package;
      thunar = lib.getExe pkgs.xfce.thunar;
      xargs = "${lib.getExe pkgs.findutils}/bin/xargs";
      xdotool = lib.getExe pkgs.xdotool;
      screenshot =
        if wayland
        then "${lib.getExe pkgs.sway-contrib.grimshot} copy area"
        else "${lib.getExe pkgs.flameshot} gui";
      playerctl = lib.getExe pkgs.playerctl;
      wpctl = pkgs.wireplumber + "/bin/wpctl";
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
      "${mod}+Shift+Return" = "exec ${terminal}";
      "${mod}+e" = "exec --no-startup-id ${thunar}";
      "${mod}+Ctrl+x" = "exec --no-startup-id ${lib.getExe pkgs.xorg.xkill}";
      # TODO: replace xdotool with wayland equivalent
      "${hyper}+space" = "exec --no-startup-id ${gopass} ls --flat | ${rofi} -dmenu -dpi $dpi | ${xargs} --no-run-if-empty ${gopass} show -o | ${xdotool} type --clearmodifiers --file -";
      "${hyper}+p" = "--release exec --no-startup-id ${screenshot}";

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
      "${mod}+space" = "exec --no-startup-id ${rofi} -show drun -dpi $dpi";
      # 1password
      "${mod}+Shift+space" = "exec ${lib.getExe pkgs._1password-gui} --quick-access";

      # audio
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
      "XF86AudioMute" = "exec --no-startup-id ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
      "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
      "XF86AudioPause" = "exec --no-startup-id ${playerctl} play-pause";

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
    inherit fonts;
    bars = [
      {
        mode = "hide";
        hiddenState = "hide";
        # use waybar if wayland
        command = lib.mkIf wayland "${lib.getExe config.programs.waybar.package}";
        # otherwise use i3status-rust
        statusCommand = lib.mkIf (!wayland) "${lib.getExe config.programs.i3status-rust.package} ${config.xdg.configHome}/i3status-rust/config-default.toml";
        position = "top";
        workspaceNumbers = false;
        inherit fonts;
        colors = {
          background = "#000000";
          focusedWorkspace = {
            background = "#F5C2E7";
            text = "#000000";
            border = "#F5C2E7";
          };
          activeWorkspace = {
            background = "#CBA6F7";
            text = "#000000";
            border = "#CBA6F7";
          };
          inactiveWorkspace = {
            background = "#000000";
            text = "#CDD6F4";
            border = "#000000";
          };
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
    gaps = {
      inner = 5;
      outer = 5;
    };
  };
  commonExtraConfig = ''
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

    # floating sticky
    for_window [class="1Password"] floating enable sticky enable border pixel 1
    for_window [window_role="PictureInPicture"] floating enable sticky enable border pixel 1

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
    for_window [class="Lightdm-settings"] floating enable
    for_window [class="Pavucontrol"] floating enable
    for_window [class="Yad" title="Authentication"] floating enable
    for_window [class="jetbrains*" title="Welcome*"] floating enable
    for_window [title="File Transfer*"] floating enable
    for_window [title="Steam Guard*"] floating enable

    # keep apps in scratchpad
    for_window [class="discord"] move scratchpad sticky
  '';
in {
  fonts.fontconfig.enable = true;

  home = lib.mkIf isLinux {
    packages = with pkgs; [
      arandr
      blueberry
      pavucontrol
      xclip
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
    zathura.enable = true;
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
      package = pkgs.nur.repos.nekowinston.picom-ft-labs;
      fade = false;
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
  systemd = lib.mkIf isLinux {
    user.targets.tray.Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  xsession = lib.mkIf isLinux {
    enable = true;
    profilePath = "${config.xdg.configHome}/profile";
    scriptPath = "${config.xdg.cacheHome}/X11/xsession";
    windowManager.i3 = {
      enable = true;
      package = pkgs.unstable.i3;
      config = commonConfig {wayland = false;};
      extraConfig = ''
        set_from_resource $dpi Xft.dpi 140
        ${commonExtraConfig}
      '';
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config =
      commonConfig {wayland = true;}
      // {
        output = {"*" = {scale = "2";};};
        startup = [
          {
            command = "${lib.getExe pkgs.nur.repos.nekowinston.swww} init";
          }
        ];
      };
    extraConfig = commonExtraConfig;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
}
