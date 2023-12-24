#!/usr/bin/env nix
#!nix shell nixpkgs#onefetch nixpkgs#scc --command bash
# shellcheck shell=bash
set -euo pipefail
onefetch --true-color never --no-bots -d lines-of-code
scc --no-cocomo .
