{ config, lib, ... }:
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    programs.i3status-rust = {
      enable = true;
      bars.top = {
        blocks = [
          {
            block = "vpn";
            driver = "mullvad";
            format_connected = "";
            format_disconnected = "";
            state_connected = "good";
            state_disconnected = "critical";
          }
          {
            block = "tea_timer";
            done_cmd = "notify-send 'Timer Finished'";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "memory";
            format = "$icon $mem_used_percents.eng(w:2)";
            interval = 1;
          }
          {
            block = "temperature";
            format = " $icon $max";
            interval = 10;
            chip = "*-isa-*";
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%d/%m %R') ";
          }
          (lib.mkIf config.services.swaync.enable {
            block = "notify";
            format = " $icon {($notification_count.eng(w:1)) |}";
            driver = "swaync";
            click = [
              {
                button = "left";
                action = "show";
              }
              {
                button = "right";
                action = "toggle_paused";
              }
            ];
          })
        ];
        settings = {
          icons.icons = "material-nf";
          theme.overrides = {
            idle_fg = "#ffffff";
            idle_bg = "#00000000";
            info_fg = "#89b4fa";
            info_bg = "#00000000";
            good_fg = "#a6e3a1";
            good_bg = "#00000000";
            warning_fg = "#fab387";
            warning_bg = "#00000000";
            critical_fg = "#f38ba8";
            critical_bg = "#00000000";
            separator = " ";
            separator_bg = "auto";
            separator_fg = "auto";
          };
        };
      };
    };

    wayland.windowManager.sway.config.bars = [
      {
        inherit (config.wayland.windowManager.sway.config) fonts;
        position = "top";
        statusCommand = "${lib.getExe config.programs.i3status-rust.package} ~/.config/i3status-rust/config-top.toml";
      }
    ];
  };
}
