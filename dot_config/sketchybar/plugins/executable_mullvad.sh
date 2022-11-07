#!/usr/bin/env bash

# path where mullvad is kept
PATH=/usr/local/bin:$PATH

if ! [ -x "$(command -v mullvad)" ]; then
  sketchybar --set "$NAME" icon=" " label=""
fi

while read -r LINE; do
  if echo "$LINE" | grep -q 'Connected'; then
    ICON=" "
  else
    ICON=" "
  fi

  sketchybar --set "$NAME" icon="$ICON"
done < <(mullvad status listen)
