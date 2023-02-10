#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gojq "callPackage ./vivid.nix {}"

dirname="$(dirname "$0")"

FLAVOURS=(
  "catppuccin-mocha"
  "catppuccin-macchiato"
  "catppuccin-frappe"
  "catppuccin-latte"
)

function to_json() {
  gojq -nR '[ inputs | split(":") ][0] | map(. | split("=") | { (.[0]) : .[1] }) | add' </dev/stdin
}

for flavour in ${FLAVOURS[@]}; do
  vivid generate $flavour | to_json >"$dirname/$flavour.json"
  vivid -m 8-bit generate $flavour | to_json >"$dirname/${flavour}-8bit.json"
done
