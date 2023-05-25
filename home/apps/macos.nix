{
  config,
  flakePath,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  xdg.configFile = lib.mkIf isDarwin {
    "sketchybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/apps/sketchybar";
      recursive = true;
    };
    "yabai/yabairc" = {
      text = let
        rule = "yabai -m rule --add";
        ignored = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off sticky=off layer=above border=off'') app);
        unmanaged = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off'') app);
      in ''
        #!/usr/bin/env sh

        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        yabai -m config \
          auto_balance off \
          focus_follows_mouse off \
          layout bsp \
          mouse_drop_action swap \
          mouse_follows_focus off \
          window_animation_duration 0.0 \
          window_border on \
          window_border_blur on \
          window_border_width 2 \
          window_gap 5 \
          left_padding 5 \
          right_padding 5 \
          top_padding 5 \
          bottom_padding 5 \
          window_origin_display default \
          window_placement second_child \
          window_shadow float \
          active_window_border_color 0xfff5c2e7 \
          normal_window_border_color 0xffcba6f7

        # auto-inject scripting additions
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        ${ignored ["JetBrains Toolbox" "Mullvad VPN" "Sip" "iStat Menus"]}
        ${unmanaged ["GOG Galaxy" "Steam" "System Settings"]}

        # etc.
        ${rule} manage=off border=off app="CleanShot"
        ${rule} manage=off sticky=on  app="OBS Studio"
      '';
      executable = true;
    };
    "skhd/skhdrc" = {
      text = let
        mapKeymaps = with builtins;
          cmd:
            concatStringsSep "\n" (map (i:
              replaceStrings ["Num"] [
                (toString (
                  if (i == 10)
                  then 0
                  else i
                ))
              ]
              cmd) (lib.range 1 10));
      in ''
        #!/usr/bin/env sh

        # WORKS WITH SIP ENABLED:
        # focus window
        cmd + ctrl - h : yabai -m window --focus west
        cmd + ctrl - j : yabai -m window --focus south
        cmd + ctrl - k : yabai -m window --focus north
        cmd + ctrl - l : yabai -m window --focus east
        # move window
        cmd + shift - h : yabai -m window --warp west
        cmd + shift - j : yabai -m window --warp south
        cmd + shift - k : yabai -m window --warp north
        cmd + shift - l : yabai -m window --warp east
        # toggle sticky/floating
        cmd + shift - s: yabai -m window --toggle sticky --toggle float --toggle topmost
        cmd + shift - d: yabai -m window --toggle float
        # rotate
        cmd + ctrl - e : yabai -m space --balance
        cmd + ctrl - r : yabai -m space --rotate 270
        # open terminal
        cmd + shift - return : open -na "''${HOME}/Applications/Home Manager Apps/WezTerm.app"
        # restart yabai
        cmd + alt - r : brew services restart yabai

        # ONLY WORKS WITH SIP DISABLED:
        # fast focus space left/right
        ctrl - left  : yabai -m space --focus prev
        ctrl - right : yabai -m space --focus next
        # switch to space
        ${mapKeymaps "cmd + ctrl - Num : yabai -m space --focus Num"}
        # send window to desktop and follow focus
        ${mapKeymaps "cmd + shift - Num : yabai -m window --space Num; yabai -m space --focus Num"}
      '';
      executable = true;
    };
  };
}
