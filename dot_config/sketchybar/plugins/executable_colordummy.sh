#!/usr/bin/env bash

# check wether or not macOS is in dark mode
if [[ $(defaults read -g AppleInterfaceStyle) != 'Dark' ]]; then
  THEME="light"
else
  THEME="dark"
fi

if [[ $THEME == 'dark' ]]; then
  ROSEWATER="f5e0dc"
  FLAMINGO="f2cdcd"
  PINK="f5c2e7"
  MAUVE="cba6f7"
  RED="f38ba8"
  MAROON="eba0ac"
  PEACH="fab387"
  YELLOW="f9e2af"
  GREEN="a6e3a1"
  TEAL="94e2d5"
  SKY="89dceb"
  SAPPHIRE="74c7ec"
  BLUE="89b4fa"
  LAVENDER="b4befe"
  TEXT="cdd6f4"
  SUBTEXT1="bac2de"
  SUBTEXT0="a6adc8"
  OVERLAY2="9399b2"
  OVERLAY1="7f849c"
  OVERLAY0="6c7086"
  SURFACE2="585b70"
  SURFACE1="45475a"
  SURFACE0="313244"
  BASE="1e1e2e"
  MANTLE="181825"
  CRUST="11111b"
else
  ROSEWATER="dc8a78"
  FLAMINGO="dd7878"
  PINK="ea76cb"
  MAUVE="8839ef"
  RED="d20f39"
  MAROON="e64553"
  PEACH="fe640b"
  YELLOW="df8e1d"
  GREEN="40a02b"
  TEAL="179299"
  SKY="04a5e5"
  SAPPHIRE="209fb5"
  BLUE="1e66f5"
  LAVENDER="7287fd"
  TEXT="4c4f69"
  SUBTEXT1="5c5f77"
  SUBTEXT0="6c6f85"
  OVERLAY2="7c7f93"
  OVERLAY1="8c8fa1"
  OVERLAY0="9ca0b0"
  SURFACE2="acb0be"
  SURFACE1="bcc0cc"
  SURFACE0="ccd0da"
  CRUST="dce0e8"
  MANTLE="e6e9ef"
  BASE="eff1f5"
fi

function color() {
  alpha=${2:-255}
  color="$1"

  case $1 in
    rosewater) color=$ROSEWATER ;;
    flamingo) color=$FLAMINGO ;;
    pink) color=$PINK ;;
    mauve) color=$MAUVE ;;
    red) color=$RED ;;
    maroon) color=$MAROON ;;
    peach) color=$PEACH ;;
    yellow) color=$YELLOW ;;
    green) color=$GREEN ;;
    teal) color=$TEAL ;;
    sky) color=$SKY ;;
    sapphire) color=$SAPPHIRE ;;
    blue) color=$BLUE ;;
    lavender) color=$LAVENDER ;;
    text) color=$TEXT ;;
    subtext1) color=$SUBTEXT1 ;;
    subtext0) color=$SUBTEXT0 ;;
    overlay2) color=$OVERLAY2 ;;
    overlay1) color=$OVERLAY1 ;;
    overlay0) color=$OVERLAY0 ;;
    surface2) color=$SURFACE2 ;;
    surface1) color=$SURFACE1 ;;
    surface0) color=$SURFACE0 ;;
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
    color=$(color crust 200) \
\
  --default \
    icon.color=$(color pink) \
    label.color=$(color text) \
\
  --set /space/ \
    icon.color=$(color mauve 128) \
    icon.highlight_color=$(color pink) \
    background.highlight_color=$(color pink) \
\
  --set window_title \
    icon.color=$(color text) \
    label.color=$(color text) \
\
  --set music \
    icon.color=$(color subtext1) \
    label.color=$(color subtext1) \
\
  --set clock \
    icon.color=$(color mauve) \
    label.color=$(color mauve) \
\
  --set date \
    icon.color=$(color blue) \
    label.color=$(color blue) \
\
  --set mullvad \
    icon.color=$(color green) \
    label.color=$(color green) \
\
  --set battery \
    icon.color=$(color yellow) \
    label.color=$(color yellow) \
\
  --set sound \
    icon.color=$(color peach) \
    label.color=$(color peach) \
\
  --set mail \
    icon.color=$(color red) \
    label.color=$(color red) \
\
  --set tasks \
    icon.color=$(color red) \
    label.color=$(color red)
