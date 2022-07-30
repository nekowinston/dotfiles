#!/usr/bin/env bash

UNREAD_ONLY=false
MAIL_DIR=~/.local/share/mail

COUNT=0

if [[ -d ${MAIL_DIR} ]]; then
  for dir in "${MAIL_DIR}"/*/; do
    # get file count for the unread mailbox, add to count
    unreads=$( find "${dir}INBOX/new" | wc -l)
    COUNT=$((COUNT+unreads))

    # also add the rest of the inbox if var is set
    if ! ($UNREAD_ONLY); then
      other=$( find "${dir}INBOX/new" | wc -l)
      COUNT=$((COUNT+other))
    fi

  done
fi

if [[ $COUNT -gt 0 ]]; then
  ICON=" "
  LABEL="$COUNT"
else
  ICON=" "
fi

sketchybar --set "$NAME" label="$LABEL" icon="$ICON"
