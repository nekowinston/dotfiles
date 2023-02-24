#!/usr/bin/env bash

if pgrep -xq Music; then
  STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
  TRACK=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
  ARTIST=$(osascript -e 'tell application "Music" to album artist of current track as string' 2>/dev/null)

  # fall back to artist, if album artist is unavailable, or generic
  if [[ -z "$ARTIST" ]] || [[ "$ARTIST" = "Various Artists" ]]; then
    ARTIST=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)
  fi

  if [[ "$STATE" = "playing" ]]; then
    LABEL="$ARTIST - $TRACK"
  else
    LABEL=""
  fi
  sketchybar --set "$NAME" label="$LABEL" \
    icon.font="Symbols Nerd Font:2048-em:18.0" \
    label.font="Victor Mono:Italic:16.0" y_offset="3"
else
  sketchybar --set "$NAME" label=""
fi
