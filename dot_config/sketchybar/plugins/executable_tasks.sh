#!/usr/bin/env bash

urg=$(task count due.before:tomorrow status:pending)
week=$(task count due.before:eow status:pending)
month=$(task count due.before:eom status:pending)
total=$(task count status:pending)

if [[ $total -eq 0 ]]; then
  ICON=" "
  LABEL="All done"
elif [[ $urg -eq 0 ]]; then
  ICON=" "
  LABEL="$week/$month/$total"
else
  ICON=" "
  LABEL="$week/$month/$total"
fi

sketchybar --set "$NAME" label="$LABEL" icon="$ICON"
