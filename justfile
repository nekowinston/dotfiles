secret-stage:
  git add -f home/secrets/default.nix

secret-unstage:
  git restore --staged home/secrets/default.nix


[linux]
boot: secret-stage && secret-unstage
  sudo nixos-rebuild boot --flake .

[macos]
check:
  darwin-rebuild check --flake .

[linux]
check:
  nix flake check .

[macos]
switch: secret-stage && secret-unstage
  darwin-rebuild switch --flake .

[linux]
switch: secret-stage && secret-unstage
  sudo nixos-rebuild switch --flake .
