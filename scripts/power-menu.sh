#!/bin/bash

CHOICE=$(printf '%s\n' \
  "Restart" \
  "Sleep" \
  "Shutdown" |
  fuzzel --dmenu \
    --prompt="POWER  " \
    --width=20)

case "$CHOICE" in
Restart)
  systemctl reboot
  ;;
Sleep)
  systemctl suspend
  ;;
Shutdown)
  systemctl poweroff
  ;;
esac
