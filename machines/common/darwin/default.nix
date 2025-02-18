{ pkgs, ... }:
{
  imports = [ ./options.nix ];

  # manipulate the global /etc/zshenv for PATH, etc.
  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      CustomSystemPreferences = {
        NSGlobalDomain = {
          AppleLanguages = [
            "en-US"
            "de-AT"
          ];
        };
      };
      ".GlobalPreferences"."com.apple.mouse.scaling" = 0.5;
      alf.stealthenabled = 1;
      dock.autohide = true;
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;

        # input
        "com.apple.keyboard.fnState" = false;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        # units & regional settings
        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    stateVersion = 4;
  };

  # Auto upgrade nix package and the daemon service.
  services.sketchybar = {
    enable = false;
    extraPackages = with pkgs; [ nushell ];
  };
}
