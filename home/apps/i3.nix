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
    size = 12.0;
  };

  recursiveMerge = with lib;
    attrList: let
      f = attrPath:
        zipAttrsWith (
          n: values:
            if tail values == []
            then head values
            else if all isList values
            then unique (concatLists values)
            else if all isAttrs values
            then f (attrPath ++ [n]) values
            else last values
        );
    in
      f [] attrList;

  commonConfig = {wayland ? false}: rec {
    modifier = "Mod4";
    focus.wrapping = "no";
    focus.mouseWarping =
      if wayland
      then "container"
      else true;
    startup = [
      {
        command = "autotiling -l2";
        always = true;
      }
      {
        command = "1password --silent";
      }
    ];
    workspaceAutoBackAndForth = true;
    terminal = "${lib.getExe config.programs.wezterm.package}";
    menu = "${lib.getExe config.programs.rofi.package}";
    defaultWorkspace = "$ws1";
    keybindings = let
      mod = modifier;
      modMove = "${mod}+Shift";
      modFocus = "${mod}+Ctrl";
      hyper = "Mod4+Mod1+Shift+Ctrl";

      thunar = lib.getExe pkgs.xfce.thunar;
      screenshot =
        if wayland
        then "${lib.getExe pkgs.sway-contrib.grimshot} copy area"
        else "${pkgs.flameshot}/bin/flameshot gui";
      playerctl = lib.getExe pkgs.playerctl;
      wpctl = pkgs.wireplumber + "/bin/wpctl";
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
      "${mod}+e" = "exec --no-startup-id ${thunar}";
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
      "${mod}+space" = "exec --no-startup-id ${menu} -show drun -dpi $dpi";
      # 1password
      "${mod}+Shift+space" = "exec ${lib.getExe pkgs._1password-gui} --quick-access";

      # audio
      "XF86AudioRaiseVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
      "XF86AudioLowerVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
      "XF86AudioMute" = "exec --no-startup-id ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
      "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
      "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";

      # modes
      "${mod}+r" = "mode \"resize\"";
      "${mod}+p" = "mode \"power: (l)ock, (e)xit, (r)eboot, (s)uspend, (h)ibernate, (S)hut off\"";
    };
    modes = {
      "power: (l)ock, (e)xit, (r)eboot, (s)uspend, (h)ibernate, (S)hut off" = let
        lock =
          if wayland
          then "swaylock"
          else "i3lock";
        msg =
          if wayland
          then "swaymsg"
          else "i3-msg";
      in {
        l = "exec --no-startup-id ${lock} --color 000000, mode \"default\"";
        e = "exec --no-startup-id ${msg} exit, mode \"default\"";
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
    bars = [
      {
        position = "top";
        trayOutput = "none";
        statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        workspaceNumbers = false;
        inherit fonts;
        colors = {
          background = "#1e1e2e";
          focusedWorkspace = {
            background = "#f5c2e7";
            text = "#11111b";
            border = "#f5c2e7";
          };
          activeWorkspace = {
            background = "#cba6f7";
            text = "#11111b";
            border = "#cba6f7";
          };
          inactiveWorkspace = {
            background = "#11111b";
            text = "#cdd6f4";
            border = "#11111b";
          };
        };
      }
    ];
    colors = rec {
      focused = {
        background = "#1e1e2e";
        border = "#f5c2e7";
        childBorder = "#f5c2e7";
        text = "#cdd6f4";
        indicator = "#f5c2e7";
      };
      urgent = {
        background = "#1e1e2e";
        border = "#f38ba8";
        childBorder = "#f38ba8";
        text = "#cdd6f4";
        indicator = "#f38ba8";
      };
      unfocused = {
        background = "#1e1e2e";
        border = "#cba6f7";
        childBorder = "#cba6f7";
        text = "#cdd6f4";
        indicator = "#cba6f7";
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
    bindsym ${(commonConfig {}).modifier}+Shift+g mode "$mode_gaps"

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
  '';
in {
  fonts.fontconfig.enable = true;

  home = lib.mkIf isLinux {
    packages = with pkgs; [
      arandr
      autotiling
      blueberry
      clipman
      flameshot
      libnotify
      pavucontrol
      sway-contrib.grimshot
      swaynotificationcenter
      wl-clipboard
      xclip
    ];
  };

  xresources = lib.mkIf isLinux {
    properties = {
      "Xft.dpi" = 192;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
    };
  };

  services = lib.mkIf isLinux {
    darkman = {
      enable = true;
      config = {
        lat = 48.210033;
        lng = 16.363449;
        useGeoclue = false;
      };
    };
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    picom = {
      enable = true;
      package = pkgs.nur.repos.nekowinston.picom-ft-labs;
      fade = false;
      backend = "glx";
      vSync = true;
      shadow = true;
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

        blur.method = "dual_kawase";
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_NET_WM_NAME@:s *?= 'Discover Voice'"
          "_NET_WM_NAME@:s *?= 'Discover Text'"
        ];
      };
    };
    udiskie.enable = true;
  };

  # https://github.com/nix-community/home-manager/issues/2064
  systemd = lib.mkIf isLinux {
    user.targets.tray.Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
    user.services.picom = lib.mkForce {};
  };

  xsession = lib.mkIf isLinux {
    enable = true;
    profilePath = "${config.xdg.configHome}/profile";
    scriptPath = "${config.xdg.cacheHome}/X11/xsession";
    windowManager.i3 = {
      enable = true;
      config = recursiveMerge [
        (commonConfig {wayland = false;})
        {
          startup = [
            {
              command = "${lib.getExe pkgs.flameshot}";
            }
            {
              command = "${lib.getExe pkgs.feh} --bg-fill ${flakePath}/home/wallpapers/dhm_1610.png --no-fehbg";
              always = true;
            }
            {
              command = "${lib.getExe config.services.picom.package}";
              always = true;
            }
          ];
        }
      ];
      extraConfig = ''
        set_from_resource $dpi Xft.dpi 192
        ${commonExtraConfig}
      '';
    };
  };

  wayland.windowManager.sway = lib.mkIf isLinux {
    enable = true;
    config = recursiveMerge [
      (commonConfig {wayland = true;})
      {
        input."type:keyboard".xkb_options = "ctrl:nocaps";
        output."*" = {
          scale = "2";
          bg = "${flakePath}/home/wallpapers/dhm_1610.png fill #171320";
        };
        startup = [
          {
            command = "wl-paste -t text --watch clipman store";
          }
          {
            command = ''
              swayidle -w \
                timeout 180 swaylock \
                timeout 360 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep swaylock
            '';
          }
        ];
      }
    ];
    extraConfig = ''
      ${commonExtraConfig}
      shadows             enable
      shadow_color        #00000099
      shadow_blur_radius  10

      corner_radius       5
      smart_corner_radius enable

      blur                enable
      blur_passes         2
      blur_radius         2
    '';
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      # session
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      # wayland
      export NIXOS_OZONE_WL=1
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
}
