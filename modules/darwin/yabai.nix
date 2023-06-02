{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.yabai;

  toYabaiConfig = opts:
    concatStringsSep "\n" (mapAttrsToList
      (p: v: "yabai -m config ${p} ${toString v}")
      opts);

  configFile = pkgs.writeScript "yabairc" (
    optionalString cfg.enableScriptingAddition ''
      ${cfg.package}/bin/yabai -m signal --add event=dock_did_restart action="sudo ${cfg.package}/bin/yabai --load-sa"
      sudo ${cfg.package}/bin/yabai --load-sa
    ''
    + optionalString (cfg.config != {}) ("\n" + (toYabaiConfig cfg.config) + "\n")
    + optionalString (cfg.extraConfig != "") ("\n" + cfg.extraConfig + "\n")
  );
in {
  disabledModules = ["services/yabai"];

  options.services.yabai = with types; {
    enable = mkEnableOption "Whether to enable the yabai window manager.";

    package = mkPackageOption pkgs "yabai" {};

    logFile = mkOption {
      type = types.str;
      default = "";
      example = "/var/tmp/yabai.log";
      description = "Path where you want to write daemon logs.";
    };

    enableScriptingAddition = mkEnableOption ''
      Whether to enable yabai's scripting-addition.
      SIP must be disabled for this to work.
    '';

    config = mkOption {
      type = attrs;
      default = {};
      example = literalExpression ''
        {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          window_placement    = "second_child";
          window_opacity      = "off";
          top_padding         = 36;
          bottom_padding      = 10;
          left_padding        = 10;
          right_padding       = 10;
          window_gap          = 10;
        }
      '';
      description = ''
        Key/Value pairs to pass to yabai's 'config' domain, via the configuration file.
      '';
    };
    extraConfig = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        yabai -m rule --add app='System Preferences' manage=off
      '';
      description = "Extra arbitrary configuration to append to the configuration file";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [cfg.package];
      launchd.user.agents.yabai.serviceConfig = rec {
        ProgramArguments = ["${cfg.package}/bin/yabai" "-c" "${configFile}"];
        KeepAlive = true;
        RunAtLoad = true;
        EnvironmentVariables.PATH = "${cfg.package}/bin:${config.environment.systemPath}";

        StandardOutPath = mkIf (cfg.logFile != "") "${cfg.logFile}";
        StandardErrorPath = StandardOutPath;
      };
    })

    (mkIf cfg.enableScriptingAddition {
      environment.etc."sudoers.d/yabai".text = let
        sha = builtins.hashFile "sha256" "${cfg.package}/bin/yabai";
      in "%admin ALL=(root) NOPASSWD: sha256:${sha} ${cfg.package}/bin/yabai --load-sa";
    })
  ];
}
