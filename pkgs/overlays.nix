{ inputs }:
[
  inputs.nix-vscode-extensions.overlays.default
  (
    final: prev:
    let
      inherit (final.stdenv) system;
      srcs = final.callPackages ../_sources/generated.nix { };
    in
    {
      nur = import inputs.nur {
        nurpkgs = final;
        pkgs = final;
        repoOverrides = {
          nekowinston = inputs.nekowinston-nur.packages.${system};
        };
      };
      nushellPlugins = (prev.nushellPlugins or { }) // {
        clipboard = final.callPackage ./nu_plugin_clipboard.nix { };
      };
      starship = prev.starship.overrideAttrs (old: {
        patches = [
          (final.fetchpatch {
            url = "https://github.com/starship/starship/commit/c397d4b5a0ece337b23529d1906fb622c1342794.patch";
            sha256 = "sha256-BKH3elz96Oa424Oz5UIKA2/BOpkym1LTestvccFinnc=";
          })
        ];
      });
      wezterm-nightly = inputs.wezterm.packages.${system}.default;
      yabai = prev.yabai.overrideAttrs (_: {
        inherit (srcs.yabai) version src;
      });
    }
  )
]
