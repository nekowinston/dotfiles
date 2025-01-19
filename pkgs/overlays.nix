{ inputs }:
[
  inputs.nix-vscode-extensions.overlays.default
  (
    final: prev:
    let
      inherit (final.stdenv) system;
      nvfetcherSrcs = final.callPackage ../_sources/generated.nix { };
    in
    {
      dark-mode-ternary = final.callPackage ./dark-mode-ternary.nix { };
      nu_scripts = prev.nu_scripts.overrideAttrs (old: {
        inherit (nvfetcherSrcs.nu_scripts) src;
        version = "0-unstable-${nvfetcherSrcs.nu_scripts.date}";
      });
      nur = import inputs.nur {
        nurpkgs = final;
        pkgs = final;
        repoOverrides = {
          nekowinston = inputs.nekowinston-nur.packages.${system};
        };
      };
      starship = prev.starship.overrideAttrs (old: {
        patches = [
          # to allow loading config values from env vars
          # https://github.com/starship/starship/pull/4439
          (final.fetchpatch {
            url = "https://github.com/starship/starship/commit/c397d4b5a0ece337b23529d1906fb622c1342794.patch";
            sha256 = "sha256-BKH3elz96Oa424Oz5UIKA2/BOpkym1LTestvccFinnc=";
          })
        ];
      });
    }
  )
]
