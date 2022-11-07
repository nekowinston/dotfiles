#!/usr/bin/env bash

# check wether or not macOS is in dark mode
if [[ $(defaults read -g AppleInterfaceStyle) != 'Dark' ]]; then
  THEME="light"
else
  THEME="dark"
fi

if [[ $THEME == 'dark' ]]; then
  PINK="f4b8e4"
  MAUVE="ca9ee6"
  TEXT="c6d0f5"
  BASE="303446"
  MANTLE="292c3c"
  CRUST="232634"
  # overrides
  BASE="000000"
  MANTLE="000000"
  CRUST="000000"
else
  PINK="ea76cb"
  MAUVE="8839ef"
  TEXT="4c4f69"
  CRUST="dce0e8"
  MANTLE="e6e9ef"
  BASE="eff1f5"
fi

function color() {
  alpha=${2:-255}
  color="$1"

  case $1 in
    pink) color=$PINK ;;
    mauve) color=$MAUVE ;;
    text) color=$TEXT ;;
    crust) color=$CRUST ;;
    mantle) color=$MANTLE ;;
    base) color=$BASE ;;
    *) color=$BASE ;;
  esac
  printf -v alpha "%02x" "$alpha"
  echo "0x${alpha}${color}"
}

sketchybar \
  --bar \
    color=$(color crust) \
\
  --default \
    icon.color=$(color pink) \
    label.color=$(color pink) \
\
  --set /space/ \
    icon.color=$(color mauve 128) \
    icon.highlight_color=$(color pink) \
\
  --set clock \
    icon.color=$(color pink) \
    label.color=$(color pink) \
\
  --set mullvad \
    icon.color=$(color pink) \
    label.color=$(color pink)

# set the yabai colours as well
yabai -m config active_window_border_color $(color base)
yabai -m config normal_window_border_color $(color base)
yabai -m config insert_feedback_color $(color base)
