{
  pkgs,
  lib,
  ...
}: {
  imports = [./options.nix];
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
      enableScriptingAddition = true;
      logFile = "/var/tmp/yabai.log";
      config = {
        layout = "bsp";

        window_gap = 5;
        left_padding = 5;
        right_padding = 5;
        top_padding = 5;
        bottom_padding = 5;
        window_animation_duration = "0.3";

        window_origin_display = "cursor";
        window_placement = "second_child";
        window_shadow = "float";

        mouse_modifier = "cmd";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
      };
      extraConfig = let
        rule = "yabai -m rule";
        mkRules = apps: options:
          builtins.concatStringsSep "\n" (map (app: ''yabai -m rule --add app="${app}" ${options}'') apps);
        unmanaged = apps: mkRules apps "manage=off";
      in ''
        # auto-inject scripting additions
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        # ensure that there are always 10 spaces
        spacestocreate=10
        spaces=$((spacestocreate - $(yabai -m query --spaces | ${pkgs.jq}/bin/jq length)))
        while [ "$spaces" -gt 0 ]; do
          yabai -m space --create
          spaces=$((spaces - 1))
        done

        # make the spaces auto-balance
        for i in {1..10}; do
          yabai -m config --space "$i" auto_balance on
        done

        ${unmanaged [
          "CleanShot"
          "GOG Galaxy"
          "Godot"
          "JetBrains Toolbox"
          "Mullvad VPN"
          "OBS Studio"
          "Sip"
          "Steam"
          "System Settings"
          "iStat Menus"
        ]}

        ${rule} --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        ${rule} --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      '';
    };
    skhd = {
      enable = true;
      skhdConfig = let
        mapKeymaps = cmd:
          builtins.concatStringsSep "\n" (
            map (i:
              builtins.replaceStrings ["Num"] [
                (toString (
                  if (i == 10)
                  then 0
                  else i
                ))
              ]
              cmd) (
              lib.range 1 10
            )
          );
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
        # send window to desktop, follow focus, and move out of scratchpad
        ${mapKeymaps "cmd + shift - Num : yabai -m window --space Num; yabai -m space --focus Num; yabai -m window --scratchpad ''"}

        cmd - tab : yabai -m window --toggle main
        cmd + shift - tab : yabai -m window --scratchpad main
      '';
    };
  };
}
