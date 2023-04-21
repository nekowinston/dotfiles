# vim:ft=just:fdm=marker

default:
  @just --choose

# check flake syntax {{{
[macos]
check:
  #!/usr/bin/env bash
  set -euxo pipefail
  if [[ -x "./result/sw/bin/darwin-rebuild" ]]; then
    ./result/sw/bin/darwin-rebuild check --flake .
  else
    nix build .\#darwinConfigurations.`hostname`.system
    ./result/sw/bin/darwin-rebuild check --flake .
  fi

[linux]
check:
  nix flake check .
# }}}

# build {{{
[macos]
switch: secret-stage && secret-unstage
  #!/usr/bin/env bash
  set -euxo pipefail
  if [[ -x "./result/sw/bin/darwin-rebuild" ]]; then
    ./result/sw/bin/darwin-rebuild switch --flake .
  else
    nix build .\#darwinConfigurations.`hostname`.system
    ./result/sw/bin/darwin-rebuild switch --flake .
  fi

[linux]
switch: secret-stage && secret-unstage
  sudo nixos-rebuild switch --flake .
[linux]
boot: secret-stage && secret-unstage
  sudo nixos-rebuild boot --flake .
# }}}

# secrets {{{
secretExists := path_exists("./home/secrets/default.nix")

secret-stage:
  {{secretExists}} && git add -f home/secrets/default.nix || exit 0
secret-unstage:
  {{secretExists}} && git restore --staged home/secrets/default.nix || exit 0

fontdir := if os() == "macos" {"$HOME/Library/Fonts"} else {"${XDG_DATA_HOME:-$HOME/.local/share}/fonts"}

install-fonts:
  #!/usr/bin/env bash
  set -euxo pipefail
  mkdir -p "{{fontdir}}"
  gpg --decrypt home/secrets/fonts.tgz.gpg | tar -xz -C "{{fontdir}}" --strip-components=1
# }}}

fetch:
  @nix run nixpkgs\#onefetch -- --true-color never --no-bots -d lines-of-code
  @nix run nixpkgs\#scc -- . --no-cocomo
