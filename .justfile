[private]
default:
  @just --choose

export NIX_CONFIG := "
  accept-flake-config = true
  extra-experimental-features = flakes nix-command
"

# wrapper around {nixos,darwin}-rebuild, always taking the flake
[private]
[macos]
rebuild *args:
  #!/usr/bin/env -S bash -euo pipefail
  dir="${TMPDIR:-/tmp}/nix-darwin"
  ! [[ -x "$dir/sw/bin/darwin-rebuild" ]] && nom build .\#darwinConfigurations.`hostname`.system -o "$dir"
  "$dir/sw/bin/darwin-rebuild" --flake . {{args}}

[private]
[linux]
rebuild *args:
  sudo nixos-rebuild --flake . {{args}} |& nom

build *args:
  @sudo true
  @just rebuild build {{args}} && nvd diff /run/current-system result

home *args:
  nix run ".#homeConfigurations.winston.activationPackage" {{args}}

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
  @just build {{args}}
  @gum confirm && just rebuild switch {{args}}

[private]
gc:
  nix-collect-garbage -d
  nix-store --optimise

[macos]
clean:
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
  @just gc

[linux]
clean:
  @just gc

fetch:
  @nix shell nixpkgs\#onefetch nixpkgs\#scc -c sh -c "onefetch --true-color never --no-bots -d lines-of-code && scc --no-cocomo ."
