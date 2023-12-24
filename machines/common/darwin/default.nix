{
  lib,
  pkgs,
  ...
}: {
  # manipulate the global /etc/zshenv for PATH, etc.
  programs.zsh.enable = true;

  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.alf.stealthenabled = 1;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services = {
    yabai = {
      enable = true;
      package = pkgs.yabai.overrideAttrs (prev: {
        version = "6.0.2";
        src = pkgs.fetchzip {
          inherit (prev.src) url;
          hash = "sha256-aFM0rtHrHsLEziDWhRwqeCy70dSAOAX4HDpqHqvnoWs=";
        };
      });
      enableScriptingAddition = true;
      logFile = "/var/tmp/yabai.log";
      config = {
        auto_balance = "off";
        focus_follows_mouse = "off";
        layout = "bsp";
        mouse_drop_action = "swap";
        mouse_follows_focus = "off";
        window_animation_duration = "0.0";
        window_gap = 5;
        left_padding = 5;
        right_padding = 5;
        top_padding = 5;
        bottom_padding = 5;
        window_origin_display = "default";
        window_placement = "second_child";
        window_shadow = "float";
      };
      extraConfig = let
        rule = "yabai -m rule --add";
        ignored = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off sticky=off layer=above'') app);
        unmanaged = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off'') app);
      in ''
        # auto-inject scripting additions
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        ${ignored ["JetBrains Toolbox" "Mullvad VPN" "Sip" "iStat Menus"]}
        ${unmanaged ["GOG Galaxy" "Steam" "System Settings"]}
        yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off

        # etc.
        ${rule} manage=off app="CleanShot"
        ${rule} manage=off sticky=on  app="OBS Studio"
      '';
    };
    skhd = {
      enable = true;
      skhdConfig = let
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
    };
  };
}
