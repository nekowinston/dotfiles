{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  home.activation.discordSettings = let
    themeUrl = flavor: "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-pink.theme.css";
    css = ''
      @import url("${themeUrl "mocha"}") (prefers-color-scheme: dark);
      @import url("${themeUrl "latte"}") (prefers-color-scheme: light);
      :root {
        --font-primary: "IBM Plex Sans", sans-serif;
        --font-headline: "IBM Plex Sans", sans-serif;
        --font-display: "IBM Plex Sans", sans-serif;
        --font-code: "Berkeley Mono", "Symbols Nerd Font", mono;
      }
    '';
    json = pkgs.writeTextFile {
      name = "discord-settings.json";
      text =
        lib.generators.toJSON {}
        {
          SKIP_HOST_UPDATE = true;
          openasar = {
            inherit css;
            setup = true;
          };
          trayBalloonShown = false;
        };
    };
    path =
      if isLinux
      then config.xdg.configHome + "/discord/settings.json"
      else if isDarwin
      then config.home.home + "/Library/Application Support/discord/settings.json"
      else throw "unsupported platform";
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      [ -d "$(dirname "${path}")" ] && cp -f "${json}" "${path}"
    '';
}
