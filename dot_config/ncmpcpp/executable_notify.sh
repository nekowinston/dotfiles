#!/usr/bin/env sh

if ! command -v mpc >/dev/null 2>&1; then
  exit 1
fi

if [ $(uname -s) = "Darwin" ]; then
  terminal-notifier -title "Now playing" -message "$(mpc --format '%title% \n%artist% - %album%' current)" -group "org.musicpd" > /dev/null
fi

if [ $(uname -s) = "Linux" ]; then
  notify-send "Now playing" "$(mpc --format '%title% \n%artist% - %album%' current)" -u low -t 5000 -a "mpd"
fi
