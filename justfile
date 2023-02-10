[macos]
switch: secret-stage && secret-unstage
  darwin-rebuild switch --flake .

[linux]
switch: secret-stage && secret-unstage
  nixos-rebuild switch --flake .

secret-stage:
  git add -f modules/secrets.nix

secret-unstage:
  git restore --staged modules/secrets.nix
