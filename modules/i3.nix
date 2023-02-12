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
      noisetorch
      pavucontrol
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
  systemd = lib.mkIf isLinux {
    user.targets.tray.Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
    user.services.autotiling = {
      Unit.Description = "Autotiling for i3";
      Service.ExecStart = "${lib.getExe pkgs.autotiling}";
      Install.WantedBy = ["default.target"];
    };
  };

  xdg = lib.mkIf isLinux {
    configFile."i3" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/i3";
      recursive = true;
    };
  };
}
