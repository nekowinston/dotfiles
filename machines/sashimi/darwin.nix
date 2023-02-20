{
  config,
  lib,
  pkgs,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
    };
  };

  users.users.winston.home = "/Users/winston";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  homebrew = {
    enable = true;
    caskArgs = {
      require_sha = true;
    };
    onActivation.autoUpdate = true;
    casks = let
      skipSha = name: {
        inherit name;
        args = {require_sha = false;};
      };
      noQuarantine = name: {
        inherit name;
        args = {no_quarantine = true;};
      };
    in [
      "1password"
      "alfred"
      "bitwarden"
      "blender"
      "discord"
      "docker"
      "firefox"
      "imageoptim"
      "insomnia"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keepassxc"
      "keka"
      "little-snitch"
      "mattermost"
      "mullvadvpn"
      "obs"
      "postman"
      "qt-creator"
      "rustdesk"
      "uninstallpkg"
      "utm"
      "yubico-yubikey-manager"
      (noQuarantine "easy-move-plus-resize")
      (noQuarantine "eloston-chromium")
      (skipSha "affinity-designer")
      (skipSha "affinity-photo")
      (skipSha "affinity-publisher")
      (skipSha "sizzy")

      # drivers
      "elgato-wave-link"
      "uhk-agent"
      (noQuarantine "vial")
    ];
    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
    ];
  };

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.alf.stealthenabled = 1;

  services = {
    dnsmasq = {
      enable = true;
      addresses."test" = "127.0.0.1";
      bind = "127.0.0.1";
    };
    skhd = {
      enable = true;
      skhdConfig = let
        yabai = lib.getExe config.services.yabai.package;
      in ''
        # WORKS WITH SIP ENABLED:
        # focus window
        cmd + ctrl - h : ${yabai} -m window --focus west
        cmd + ctrl - j : ${yabai} -m window --focus south
        cmd + ctrl - k : ${yabai} -m window --focus north
        cmd + ctrl - l : ${yabai} -m window --focus east
        # move window
        cmd + shift - h : ${yabai} -m window --warp west
        cmd + shift - j : ${yabai} -m window --warp south
        cmd + shift - k : ${yabai} -m window --warp north
        cmd + shift - l : ${yabai} -m window --warp east
        # toggle sticky/floating
        cmd + shift - s: ${yabai} -m window --toggle sticky --toggle float --toggle topmost
        cmd + shift - d: ${yabai} -m window --toggle float
        # rotate
        cmd + ctrl - e : ${yabai} -m space --balance
        cmd + ctrl - r : ${yabai} -m space --rotate 270
        # open terminal
        cmd + shift - return : open -na "WezTerm"
        # restart yabai
        cmd + alt - r : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai"

        # ONLY WORKS WITH SIP DISABLED:
        # fast focus space left/right
        ctrl - left  : ${yabai} -m space --focus prev
        ctrl - right : ${yabai} -m space --focus next
        # switch to space
        cmd + ctrl - 1 : ${yabai} -m space --focus 1
        cmd + ctrl - 2 : ${yabai} -m space --focus 2
        cmd + ctrl - 3 : ${yabai} -m space --focus 3
        cmd + ctrl - 4 : ${yabai} -m space --focus 4
        cmd + ctrl - 5 : ${yabai} -m space --focus 5
        cmd + ctrl - 6 : ${yabai} -m space --focus 6
        cmd + ctrl - 7 : ${yabai} -m space --focus 7
        cmd + ctrl - 8 : ${yabai} -m space --focus 8
        cmd + ctrl - 9 : ${yabai} -m space --focus 9
        cmd + ctrl - 0 : ${yabai} -m space --focus 10
        # send window to desktop and follow focus
        cmd + shift - 1 : ${yabai} -m window --space 1; ${yabai} -m space --focus 1
        cmd + shift - 2 : ${yabai} -m window --space 2; ${yabai} -m space --focus 2
        cmd + shift - 3 : ${yabai} -m window --space 3; ${yabai} -m space --focus 3
        cmd + shift - 4 : ${yabai} -m window --space 4; ${yabai} -m space --focus 4
        cmd + shift - 5 : ${yabai} -m window --space 5; ${yabai} -m space --focus 5
        cmd + shift - 6 : ${yabai} -m window --space 6; ${yabai} -m space --focus 6
        cmd + shift - 7 : ${yabai} -m window --space 7; ${yabai} -m space --focus 7
        cmd + shift - 8 : ${yabai} -m window --space 8; ${yabai} -m space --focus 8
        cmd + shift - 9 : ${yabai} -m window --space 9; ${yabai} -m space --focus 9
        cmd + shift - 0 : ${yabai} -m window --space 10; ${yabai} -m space --focus 10
      '';
    };
    yabai = {
      enable = true;
      package = pkgs.unstable.yabai;
      extraConfig = let
        rule = "yabai -m rule --add";
        ignored = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off sticky=off layer=above border=off'') app);
        unmanaged = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off'') app);
      in ''
        # auto-inject scripting additions
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        ${ignored ["JetBrains Toolbox" "Mullvad VPN" "Sip" "iStat Menus"]}
        ${unmanaged ["GOG Galaxy" "Steam" "System Settings"]}

        # etc.
        ${rule} manage=off border=off app="CleanShot"
        ${rule} manage=off sticky=on  app="OBS Studio"
      '';
      config = {
        auto_balance = "off";
        focus_follows_mouse = "off";
        layout = "bsp";
        mouse_drop_action = "swap";
        mouse_follows_focus = "off";
        mouse_modifier = "off";
        window_animation_duration = "0.1";
        window_border = "on";
        window_border_blur = "on";
        window_border_width = "2";
        # this actually looks like hot trash
        # window_border_radius = "0";
        window_gap = "0";
        window_origin_display = "default";
        window_placement = "second_child";
        window_shadow = "float";
        active_window_border_color = "0xfff5c2e7";
        normal_window_border_color = "0xffcba6f7";
      };
    };
  };
}
