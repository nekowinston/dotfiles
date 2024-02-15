{inputs}: [
  inputs.nix-vscode-extensions.overlays.default
  inputs.catppuccin-vsc.overlays.default
  (final: prev: {
    starship = prev.starship.overrideAttrs (old: {
      patches = [
        (prev.fetchpatch {
          url = "https://github.com/starship/starship/pull/4439.patch";
          sha256 = "sha256-BKH3elz96Oa424Oz5UIKA2/BOpkym1LTestvccFinnc=";
        })
      ];
    });
    sway-unwrapped = inputs.swayfx.packages.${prev.system}.default;
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
