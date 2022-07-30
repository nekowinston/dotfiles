#!/usr/bin/env sh

if pgrep -xq Music; then
  STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null || echo "")
  TRACK=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null || echo "")
  ARTIST=$(osascript -e 'tell application "Music" to album artist of current track as string' 2>/dev/null || echo "")

  if [ "$STATE" = "playing" ]; then
    ICON=""
    LABEL="$ARTIST - $TRACK"
  else
    ICON=""
    if [ "$TRACK" = "" ] || [ "$ARTIST" = "" ]; then
      LABEL="paused"
    else
      LABEL="$ARTIST - $TRACK"
    fi
  fi
  sketchybar --set "$NAME" icon="$ICON" label="$LABEL" --add event "${NAME}-changed"
else
  sketchybar --set "$NAME" icon="" label="" --add event "${NAME}-changed"
fi
