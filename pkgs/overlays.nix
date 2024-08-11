{ inputs }:
[
  inputs.nix-vscode-extensions.overlays.default
  (
    final: prev:
    let
      srcs = prev.callPackages ../_sources/generated.nix { };
    in
    {
      nushellPlugins = (prev.nushellPlugins or { }) // {
        clipboard = prev.callPackage ./nu_plugin_clipboard.nix { };
      };
      starship = prev.starship.overrideAttrs (old: {
        patches = [
          (prev.fetchpatch {
            url = "https://github.com/starship/starship/pull/4439.patch";
            sha256 = "sha256-BKH3elz96Oa424Oz5UIKA2/BOpkym1LTestvccFinnc=";
          })
        ];
      });
      yabai = prev.yabai.overrideAttrs (_: {
        inherit (srcs.yabai) version src;
      });
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          nekowinston = inputs.nekowinston-nur.packages.${prev.stdenv.system};
        };
      };
    }
  )
]
