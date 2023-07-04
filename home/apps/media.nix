{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  programs.mpv.enable = isLinux;
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
  };
  programs.zathura.enable = true;
  xdg.mimeApps.defaultApplications."application/pdf" = "zathura.desktop";

  programs.ncmpcpp = {
    enable = true;
    settings."lyrics_directory" = "${config.xdg.dataHome}/ncmpcpp";
    bindings =
      lib.mapAttrsToList (key: command: {inherit key command;})
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
    discord-applemusic-rich-presence.enable = isDarwin;
    mpd.enable = isLinux;
    mpdris2 = {
      enable = isLinux;
      multimediaKeys = true;
      notifications = true;
    };
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
    mpd-mpris.enable = isLinux;
  };

  launchd.agents.mpd = {
    enable = true;
    config = let
      mpdConf = pkgs.writeText "mpd.conf" (let
        baseDir = config.xdg.dataHome + "/mpd";
      in ''
        music_directory     "${config.xdg.userDirs.music}"
        playlist_directory  "${baseDir}/playlists"
        db_file             "${baseDir}/database"
        pid_file            "${baseDir}/mpd.pid"
        state_file          "${baseDir}/state"
        log_file            "${baseDir}/log"
        auto_update "yes"
        port                "6600"
        bind_to_address     "127.0.0.1"
        audio_output {
          type "osx"
          name "CoreAudio"
          mixer_type "software"
        }
      '');
    in {
      ProgramArguments = ["${pkgs.mpd}/bin/mpd" "--no-daemon" "${mpdConf}"];
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "${config.xdg.cacheHome}/mpd.log";
      StandardOutPath = "${config.xdg.cacheHome}/mpd.log";
    };
  };
}
