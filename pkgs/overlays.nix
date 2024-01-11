{inputs}: [
  inputs.swayfx.overlays.default
  inputs.nix-vscode-extensions.overlays.default
  inputs.catppuccin-vsc.overlays.default
  (final: prev: {
    yabai = prev.yabai.overrideAttrs (old: rec {
      version = "6.0.6";
      src = prev.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-G4BbYU4mgV8Jap8a872/YtoXU/hwUhFyLXdcuT1jldI=";
      };
    });
    nur = import inputs.nur {
      nurpkgs = prev;
      pkgs = prev;
      repoOverrides = {
        nekowinston = import inputs.nekowinston-nur {inherit (prev) pkgs;};
        caarlos0 = import inputs.caarlos0-nur {
          inherit (prev) pkgs;
          overlays = [
            (final: prev: {
              discord-applemusic-rich-presence = prev.discord-applemusic-rich-presence.overrideAttrs {
                patches = [./patches/discord-applemusic-rich-presence.patch];
              };
            })
          ];
        };
      };
    };
  })
]
