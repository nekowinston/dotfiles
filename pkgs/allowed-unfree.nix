{ lib }:
pkg:
builtins.elem (lib.getName pkg) [
  "1password"
  "1password-cli"
  "discord"
  "graalvm-oracle"
  "obsidian"
  "steam"
  "steam-unwrapped"
  "uhk-agent"
  "uhk-udev-rules"
  "xkcd-font"
  # firefox extensions
  "languagetool"
  "onepassword-password-manager"
]
