#!/usr/bin/env bash

# path where mullvad is kept
PATH=/usr/local/bin:$PATH

if command -v mullvad &> /dev/null; then
  MULLVAD_STATUS=$(mullvad status)

  if echo "$MULLVAD_STATUS" | grep -q 'Connected'; then
    OUTPUT=$(mullvad status | cut -d " " -f 3 | cut -d "-" -f 1 | tr '/a-z/' '/A-Z/')
    ICON=" "
  else
    ICON=" "
  fi

else
  ICON=" "
  OUTPUT=""
fi

sketchybar --set "$NAME" icon="$ICON" label="$OUTPUT"
