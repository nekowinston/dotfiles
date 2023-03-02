{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in {
  programs.ncmpcpp = {
    enable = true;
    bindings =
      lib.mapAttrsToList (key: command: {
        key = key;
        command = command;
      })
      {
        "j" = "scroll_down";
        "k" = "scroll_up";
        "J" = ["select_item" "scroll_down"];
        "K" = ["select_item" "scroll_up"];
        "h" = "previous_column";
        "l" = "next_column";
        "ctrl-b" = "page_up";
        "ctrl-u" = "page_up";
        "ctrl-f" = "page_down";
        "ctrl-d" = "page_down";
        "g" = "move_home";
        "G" = "move_end";
        "n" = "next_found_item";
        "N" = "previous_found_item";
      };
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

  home.packages = lib.mkIf isLinux [pkgs.unstable.cider];

  launchd.agents.discord-applemusic-rich-presence = {
    enable = true;
    config = {
      ProgramArguments = ["${lib.getExe pkgs.nur.repos.nekowinston.discord-applemusic-rich-presence}"];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "${config.xdg.cacheHome}/discord-applemusic-rich-presence.log";
      StandardOutPath = "${config.xdg.cacheHome}/discord-applemusic-rich-presence.log";
    };
  };
}
