{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  programs.ncmpcpp = {
    enable = isLinux;
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "ctrl-b";
        command = "page_up";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-f";
        command = "page_down";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
    ];
  };

  services = {
    mpd.enable = isLinux;
    mpd-discord-rpc = {
      enable = isLinux;
      settings = {
        format = {
          state = "$artist";
          large_image = "https://cdn.discordapp.com/emojis/743725086262951957.gif";
          large_text = "$album";
          small_image = "https://cdn.discordapp.com/emojis/743723149455261717.png";
          small_text = "pretty fucking based";
        };
      };
    };
  };

  home.packages = lib.mkIf isDarwin [pkgs.nur.repos.nekowinston.discord-applemusic-rich-presence];

  launchd.agents.discord-applemusic-rich-presence = {
    enable = true;
    config = {
      ProgramArguments = ["${lib.getExe pkgs.nur.repos.nekowinston.discord-applemusic-rich-presence}"];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "${config.home.homeDirectory}/.cache/discord-applemusic-rich-presence.log";
      StandardOutPath = "${config.home.homeDirectory}/.cache/discord-applemusic-rich-presence.log";
    };
  };
}
