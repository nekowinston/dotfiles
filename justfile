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

[linux]
install-fonts:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -p $XDG_DATA_HOME/fonts
  gpg --decrypt home/secrets/fonts.tgz.gpg | tar -xz -C $XDG_DATA_HOME/fonts --strip-components=1

[macos]
install-fonts:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -p ~/Library/Fonts
  gpg --decrypt home/secrets/fonts.tgz.gpg | tar -xz -C ~/Library/Fonts --strip-components=1
