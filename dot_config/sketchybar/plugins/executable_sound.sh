#!/usr/bin/env bash

VOLUME=$(osascript -e "get volume settings" | cut -d " " -d ":" -f2 | cut -d "," -f1)
MUTED=$(osascript -e "get volume settings" | grep "muted:true")

if [[ "$MUTED" != "" ]]; then
ICON="ﱝ "
else
case ${VOLUME} in
  100) ICON="墳";;
  9[0-9]) ICON="墳";;
  8[0-9]) ICON="墳";;
  7[0-9]) ICON="墳";;
  6[0-9]) ICON="奔";;
  5[0-9]) ICON="奔";;
  4[0-9]) ICON="奔";;
  3[0-9]) ICON="奔";;
  2[0-9]) ICON="奄";;
  1[0-9]) ICON="奄";;
  [0-9]) ICON="奄";;
  *) ICON="奄"
esac
fi

sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
