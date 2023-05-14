# vim:ft=just:fdm=marker

[private]
default:
  @just --choose

# wrapper around {nixos,darwin}-rebuild, always taking the flake {{{
[private]
[macos]
rebuild *args:
  #!/usr/bin/env bash
  set -euxo pipefail
  dir="{{env_var('TMPDIR')}}/nix-darwin"
  ! [[ -x "$dir/sw/bin/darwin-rebuild" ]] && nix build .\#darwinConfigurations.`hostname`.system -o "$dir"
  "$dir/sw/bin/darwin-rebuild" --flake . {{args}}

[private]
[linux]
rebuild *args:
  sudo nixos-rebuild --flake . {{args}}
# }}}

build *args:
  @just rebuild build {{args}}

[linux]
boot *args:
  @just rebuild boot {{args}}

check *args:
  @just rebuild check {{args}}

switch *args:
  @just rebuild switch {{args}}

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
