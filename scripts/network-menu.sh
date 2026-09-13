#!/bin/bash

IFACE="wlan0"

SSID=$(iw dev "$IFACE" link 2>/dev/null |
  awk -F': ' '/SSID:/ {print $2}')

CHOICE=$(printf '%s\n' \
  "Connected: ${SSID:-Disconnected}" \
  "Open Impala" |
  fuzzel --dmenu \
    --prompt="NETWORK  " \
    --width=35)

case "$CHOICE" in
"Open Impala")
  kitty -e impala
  ;;
esac
