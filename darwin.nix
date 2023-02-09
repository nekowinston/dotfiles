{ config, lib, pkgs, ... }:

{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" ];
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "1password"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "alfred"
      "bitwarden"
      "blender"
      "discord"
      "docker"
      "easy-move-plus-resize"
      "eloston-chromium"
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
      "sizzy"
      "uninstallpkg"
      "utm"
      "yubico-yubikey-manager"

      # drivers
      "elgato-wave-link"
      "uhk-agent"
      "vial"
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
      skhdConfig = builtins.readFile ./modules/skhd/skhdrc;
    };
    yabai = {
      enable = true;
      package = pkgs.unstable.yabai;
      extraConfig = let
        rule = "yabai -m rule --add";
        ignored = app: builtins.concatStringsSep "\n" (map(e: ''${rule} app="${e}" manage=off sticky=off layer=above border=off'') app);
        unmanaged = app: builtins.concatStringsSep "\n" (map(e: ''${rule} app="${e}" manage=off'') app);
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
