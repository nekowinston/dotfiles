[macos]
switch:
  darwin-rebuild switch --flake .

[linux]
switch:
  nixos-rebuild switch --flake .

home:
  git add -f modules/secrets.nix
  home-manager switch --flake .
  git restore --staged modules/secrets.nix
