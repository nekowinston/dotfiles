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

      @media (max-width: 1024px) {
        nav[aria-label="Servers sidebar"] {
          display: none;
        }
        .container-1-ERn5 {
          margin: 1.3rem 0 0 0;
        }
      }

      @media (max-width: 768px) {
        div[class^="base-"] > div[class^="content-"] > div[class^="sidebar-"] {
          display: none;
        }
        .container-ZMc96U {
          margin: 1.3rem 0 0 0;
        }
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
          MIN_WIDTH = 0;
          MIN_HEIGHT = 0;
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
