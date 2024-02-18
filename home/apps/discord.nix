{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  config = lib.mkIf config.isGraphical {
    home.packages = [(pkgs.discord.override {withOpenASAR = true;})];
    home.activation.discordSettings = let
      json = pkgs.writeTextFile {
        name = "discord-settings.json";
        text = lib.generators.toJSON {} {
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
          MIN_WIDTH = 0;
          MIN_HEIGHT = 0;
          openasar = {
            css = builtins.readFile ./discord/custom.css;
            setup = true;
          };
          trayBalloonShown = false;
          SKIP_HOST_UPDATE = true;
        };
      };
      path =
        if isLinux
        then "${config.xdg.configHome}/discord/settings.json"
        else if isDarwin
        then "${config.home.homeDirectory}/Library/Application Support/discord/settings.json"
        else throw "unsupported platform";
    in
      # gets written as a file after the writeBoundary to keep it mutable
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$(dirname "${path}")"
        cp -f "${json}" "${path}"
      '';
  };
}
