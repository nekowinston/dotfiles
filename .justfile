[private]
@default:
  just --choose

export NIX_CONFIG := "
  accept-flake-config = true
  extra-experimental-features = flakes nix-command pipe-operators
"

# wrapper around {nixos,darwin}-rebuild, always taking the flake
[private]
[macos]
rebuild *args:
  darwin-rebuild --flake . {{args}} |& nom

[private]
[linux]
rebuild *args:
  nixos-rebuild --flake . --ask-sudo-password {{args}} |& nom

@build *args:
  just rebuild build {{args}}
  nvd diff /run/current-system result

home *args:
  nix run ".#homeConfigurations.winston.activationPackage" {{args}}

[linux]
@boot *args:
  just rebuild boot {{args}}

[macos]
@check *args:
  just rebuild check {{args}}

[linux]
@check *args:
  just rebuild dry-build {{args}}

@switch *args:
  just build {{args}}
  just confirm-switch {{args}}

[confirm]
[private]
@confirm-switch *args:
  just rebuild switch {{args}}

clean:
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
  nix-collect-garbage -d
  nix store optimise
