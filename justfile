# vim:ft=just:fdm=marker

default:
  @just --choose

# check flake syntax {{{
[macos]
check:
  darwin-rebuild check --flake .

[linux]
check:
  nix flake check .
# }}}

# build {{{
[macos]
switch: secret-stage && secret-unstage
  darwin-rebuild switch --flake .

[linux]
switch: secret-stage && secret-unstage
  sudo nixos-rebuild switch --flake .
[linux]
boot: secret-stage && secret-unstage
  sudo nixos-rebuild boot --flake .
# }}}

# secrets {{{
secret-stage:
  git add -f home/secrets/default.nix
secret-unstage:
  git restore --staged home/secrets/default.nix

fontdir := if os() == "macos" {"$HOME/Library/Fonts"} else {"${XDG_DATA_HOME:-$HOME/.local/share}/fonts"}

install-fonts:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -p "{{fontdir}}"
  gpg --decrypt home/secrets/fonts.tgz.gpg | tar -xz -C "{{fontdir}}" --strip-components=1
# }}}

fetch:
  @nix run nixpkgs\#onefetch -- --true-color never --no-bots -d lines-of-code
  @nix run nixpkgs\#scc -- . --no-cocomo
