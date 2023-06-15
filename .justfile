[private]
default:
  @just --choose

# wrapper around {nixos,darwin}-rebuild, always taking the flake
[private]
[macos]
rebuild *args:
  #!/usr/bin/env bash
  set -euxo pipefail
  dir="{{join(env_var('TMPDIR'), 'nix-darwin')}}"
  ! [[ -x "$dir/sw/bin/darwin-rebuild" ]] && nix build .\#darwinConfigurations.`hostname`.system -o "$dir"
  "$dir/sw/bin/darwin-rebuild" --flake . {{args}}

[private]
[linux]
rebuild *args:
  sudo nixos-rebuild --flake . {{args}}

build *args:
  @just rebuild build {{args}}

home *args:
  nix run ".#homeConfigurations.winston.activationPackage"

[linux]
boot *args:
  @just rebuild boot {{args}}

[macos]
check *args:
  @just rebuild check {{args}}

[linux]
check *args:
  @just rebuild test {{args}}

switch *args:
  @just rebuild switch {{args}}

fetch:
  @nix shell nixpkgs\#onefetch nixpkgs\#scc -c sh -c "onefetch --true-color never --no-bots -d lines-of-code && scc --no-cocomo ."
