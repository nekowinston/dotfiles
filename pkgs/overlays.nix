{ inputs }:
[
  inputs.nix-vscode-extensions.overlays.default
  (
    final: prev:
    let
      inherit (final) lib;
      inherit (final.stdenv) system;
      nvfetcherSrcs = final.callPackage ../_sources/generated.nix { };
    in
    {
      dark-mode-ternary = final.callPackage ./dark-mode-ternary.nix { };
      nu_scripts = prev.nu_scripts.overrideAttrs (old: {
        inherit (nvfetcherSrcs.nu_scripts) src;
        postPatch = ''
          rm -rf themes/screenshots
        '';
        version = "0-unstable-${nvfetcherSrcs.nu_scripts.date}";
      });
      nur = import inputs.nur {
        nurpkgs = final;
        pkgs = final;
      };
      rs-git-fsmonitor = final.rustPlatform.buildRustPackage rec {
        pname = "rs-git-fsmonitor";
        version = "0.2.0-git-rust-client";

        src = final.fetchFromGitHub {
          owner = "nekowinston";
          repo = "rs-git-fsmonitor";
          rev = "7317d9b201a540e12468bca3272baa59be1a5382";
          sha256 = "sha256-VdF7FamqveSJLrcspTLZ0LGk7SMgYG1+muryCYLjP78=";
        };

        cargoHash = "sha256-gcWi2gczg6eiYIJrrP76e9PqMBll0MTnAFT5BA/30as=";

        nativeBuildInputs = [ final.makeWrapper ];

        fixupPhase = ''
          wrapProgram $out/bin/rs-git-fsmonitor --prefix PATH ":" "${lib.makeBinPath [ final.watchman ]}"
        '';

        meta = {
          description = "Fast git core.fsmonitor hook written in Rust";
          homepage = "https://github.com/jgavris/rs-git-fsmonitor";
          changelog = "https://github.com/jgavris/rs-git-fsmonitor/releases/tag/v${version}";
          license = lib.licenses.mit;
          maintainers = [ ];
          mainProgram = "rs-git-fsmonitor";
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
