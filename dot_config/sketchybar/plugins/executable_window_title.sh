#!/usr/bin/env bash

case "$INFO" in
  # IDEs
  "CLion") ;&
  "GoLand") ;&
  "PhpStorm") ;&
  "PyCharm") ;&
  "WebStorm") ;&
  "Lapce") ;&
  "Xcode") ICON=" ";;
  "Neovide") ICON=" ";;

  # developer
  "Docker") ICON=" ";;

  # terminals
  "Kitty") ;&
  "iTerm") ;&
  "Terminal") ;&
  "WezTerm") ICON=" ";;

  # browsers
  "Chromium") ICON=" ";;
  "Firefox") ICON=" ";;
  "Safari") ICON=" ";;
  "qutebrowser") ICON=" ";;

  # system
  "App Store") ICON=" ";;
  "Books") ICON=" ";;
  "Finder") ICON=" ";;
  "Music") ICON="ﱘ ";;
  "Podcasts") ICON=" ";;
  "Photos") ICON=" ";;
  "Preview") ICON=" ";;
  "System Preferences") ICON=" ";;

  # chat
  "Discord") ICON="ﭮ ";;
  "Mattermost") ICON=" ";;
  "Slack") ICON=" ";;

  # creativity
  "Affinity Designer") ICON=" ";;
  "Affinity Photo") ICON=" ";;
  "Affinity Publisher") ICON=" ";;
  "Blender") ICON=" ";;
  "Final Cut") ICON=" ";;
  "Garageband") ICON=" ";;
  "Logic Pro X") ICON=" ";;
  "iMovie") ICON=" ";;

  # password managers
  "GPG Keychain") ;&
  "KeePassXC") ;&
  "LastPass") ;&
  "1Password") ICON=" ";;

  # other
  "Audible") ICON=" ";;
  "Pocket Casts") ICON=" ";;
  "Setapp") ICON=" ";;
  "Spotify") ICON=" ";;
  "Steam") ICON=" ";;
  *) ICON="ﬓ ";;
esac

sketchybar --set "$NAME" label="$INFO" icon="$ICON"
