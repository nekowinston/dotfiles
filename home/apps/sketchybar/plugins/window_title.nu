#!/usr/bin/env nu

let icon = match ($env.INFO?) {
  # IDEs
  "CLion" | "GoLand" | "PhpStorm" | "PyCharm" | RustRover | "WebStorm" | "Xcode" => " ",
  "Neovide" => " ",

  # developer
  "Docker" => " ",

  # terminals
  "Kitty" | "iTerm" | "Terminal" | "WezTerm" => " ",

  # browsers
  "Chromium" | "Firefox" | "Safari" | "qutebrowser" => " ",

  # system
  "App Store" => " ",
  "Books" => " ",
  "Finder" => "󰀶 ",
  "Music" => "󰝚 ",
  "Podcasts" => " ",
  "Photos" => " ",
  "Preview" => " ",
  "System Preferences" => " ",

  # chat
  "Discord" => "󰙯 ",
  "Mattermost" => " ",
  "Slack" => " ",

  # creativity
  "Affinity Designer" => "󰃣 ",
  "Affinity Photo" => "󰃣 ",
  "Affinity Publisher" => "󰈙 ",
  "Blender" => "󰂫 ",
  "Final Cut" => " ",
  "Garageband" => "󰋄 ",
  "Logic Pro X" => "󰋄 ",
  "iMovie" => " ",

  # password managers
  "GPG Keychain" | "KeePassXC" | "LastPass" | "1Password" => "󰌋 ",

  # other
  "Audible" => "󰋋 ",
  "Pocket Casts" => " ",
  "Setapp" => " ",
  "Spotify" => " ",
  "Steam" => " ",

  _ => "󰘔 ",
}

(sketchybar
  --set $env.NAME $"label=($env.INFO? | default '')" $"icon=($icon)"
  icon.font="Symbols Nerd Font:2048-em:18.0"
  label.font="Berkeley Mono:Bold:16.0" y_offset="3")
