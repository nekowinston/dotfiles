#!/usr/bin/env bash

DATE="$(ddate +'%{%A, %b %d%}')"
sketchybar --set "$NAME" label="$DATE" icon=" "
