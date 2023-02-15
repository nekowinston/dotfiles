[macos]
switch: secret-stage && secret-unstage
  darwin-rebuild switch --flake .

[linux]
switch: secret-stage && secret-unstage
  sudo nixos-rebuild switch --flake .

[linux]
boot: secret-stage && secret-unstage
  sudo nixos-rebuild boot --flake .

secret-stage:
  git add -f modules/secrets.nix

secret-unstage:
  git restore --staged modules/secrets.nix
