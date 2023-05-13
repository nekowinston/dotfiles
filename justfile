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
switch:
  #!/usr/bin/env bash
  set -euxo pipefail
  if [[ -x "./result/sw/bin/darwin-rebuild" ]]; then
    ./result/sw/bin/darwin-rebuild switch --flake .
  else
    nix build .\#darwinConfigurations.`hostname`.system
    ./result/sw/bin/darwin-rebuild switch --flake .
  fi

[linux]
switch:
  sudo nixos-rebuild switch --flake .
[linux]
boot:
  sudo nixos-rebuild boot --flake .
# }}}

secretExists := path_exists("./home/secrets/default.nix")

fontdir := if os() == "macos" {"$HOME/Library/Fonts"} else {"${XDG_DATA_HOME:-$HOME/.local/share}/fonts"}
install-fonts:
  install -Dm644 home/secrets/fonts/* "{{fontdir}}"

fetch:
  @nix run nixpkgs\#onefetch -- --true-color never --no-bots -d lines-of-code
  @nix run nixpkgs\#scc -- . --no-cocomo
