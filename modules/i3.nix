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
      blueberry
      libnotify
      pavucontrol
    ];
  };

  gtk = lib.mkIf isLinux {
    enable = true;

    cursorTheme = {
      name = "Catppuccin-Mocha-Cursors";
      package = pkgs.catppuccin-cursors.mochaPink;
    };
    iconTheme = {
      package = pkgs.papirus-folders-catppuccin.override {
        flavour = "mocha";
        accent = "pink";
      };
      name = "Papirus-Dark";
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.unstable.catppuccin-gtk;
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  };

  programs = lib.mkIf isLinux {
    autorandr.enable = true;

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

    rofi = {
      enable = true;
      font = "Berkeley Mono 14";
      extraConfig.icon-theme = "Papirus-Dark";
      terminal = "${lib.getExe pkgs.wezterm}";
      theme = ./rofi/theme.rasi;
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
      settings = {
        animations = true;
        blur = lib.mkIf riced {
          method = "dual_kawase";
        };
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
    configFile = {
      "i3" = {
        source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/modules/i3";
        recursive = true;
      };
    };
  };
}
