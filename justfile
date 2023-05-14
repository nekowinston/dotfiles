# vim:ft=just:fdm=marker

[private]
default:
  @just --choose

# wrapper around {nixos,darwin}-rebuild, always taking the flake {{{
[private]
[macos]
rebuild args:
  #!/usr/bin/env bash
  set -euxo pipefail
  ! [[ -x "./result/sw/bin/darwin-rebuild" ]] && nix build .\#darwinConfigurations.`hostname`.system
  ./result/sw/bin/darwin-rebuild "{{args}}" --flake .

[private]
[linux]
rebuild args:
  sudo nixos-rebuild "{{args}}" --flake .
# }}}

build:
  just rebuild build

[linux]
boot:
  just rebuild boot

check:
  just rebuild check

switch:
  just rebuild switch

# these will fail, should variables not be set
fontdir := if os() == "macos" {
  env_var('HOME') + "/Library/Fonts"
} else {
  env_var_or_default('XDG_DATA_HOME', env_var('HOME') + "/.local/share") + "/fonts"
}
# TODO: move these to the home.activation hook
install-fonts:
  install -Dm644 {{justfile_directory()}}/home/secrets/fonts/* "{{fontdir}}"

fetch:
  @nix shell nixpkgs\#onefetch nixpkgs\#scc -c sh -c "onefetch --true-color never --no-bots -d lines-of-code && scc --no-cocomo ."
