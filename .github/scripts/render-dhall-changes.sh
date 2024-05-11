#!/usr/bin/env bash
set -euo pipefail

for file in .github/workflows/*.dhall; do
  nix shell nixpkgs#dhall-yaml -c dhall-to-yaml-ng --file "$file" >"${file%.dhall}.yml"
done
