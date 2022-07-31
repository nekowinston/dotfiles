#!/usr/bin/env bash

# path where mullvad is kept
PATH=/usr/local/bin:$PATH

if ! [ -x "$(command -v mullvad)" ]; then
  sketchybar --set "$NAME" icon=" " label=""
fi

while read -r LINE; do
  if echo "$LINE" | grep -q 'Connected'; then
    # regex grep the relay, e.g. se7 for sweden-7
    OUTPUT=$(echo "$LINE" | grep -oE "\w{2}\d+")
    ICON=" "
  else
    ICON=" "
  fi

  sketchybar --set "$NAME" icon="$ICON" label="${OUTPUT^^}"
done < <(mullvad status listen)
