{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
    })
  ];
  home.activation.discordSettings = let
    css = ''
      :root {
        --font-primary: "IBM Plex Sans", sans-serif;
        --font-headline: "IBM Plex Sans", sans-serif;
        --font-display: "IBM Plex Sans", sans-serif;
        --font-code: "Cascadia Code", "Symbols Nerd Font", mono;
      }

      @media (max-width: 1024px) {
        nav[aria-label="Servers sidebar"] {
          display: none;
        }
        .platform-osx div[class^="base_"] > div[class^="content_"] > div[class^="sidebar_"],
        .platform-osx div[class^="base_"] > div[class^="content_"] > main[class^="container_"],
        .platform-osx div[class^="base_"] > div[class^="content_"] > div[class^="chat_"] {
          padding-top: 32px !important;
        }
      }

      @media (max-width: 768px) {
        div[class^="base_"] > div[class^="content_"] > div[class^="sidebar_"] {
          display: none;
        }
      }

      main[class^="chatContent_"] form div[class^="buttons_"],
      main[class^="chatContent_"] form div[class^="attachWrapper_"] {
        display: none;
      }
    '';
    json = pkgs.writeTextFile {
      name = "discord-settings.json";
      text =
        lib.generators.toJSON {}
        {
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
          MIN_WIDTH = 0;
          MIN_HEIGHT = 0;
          openasar = {
            inherit css;
            setup = true;
          };
          trayBalloonShown = false;
          SKIP_HOST_UPDATE = true;
        };
    };
    path =
      if isLinux
      then config.xdg.configHome + "/discord/settings.json"
      else if isDarwin
      then config.home.homeDirectory + "/Library/Application Support/discord/settings.json"
      else throw "unsupported platform";
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$(dirname "${path}")"
      cp -f "${json}" "${path}"
    '';
}
