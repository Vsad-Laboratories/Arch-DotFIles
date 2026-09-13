#!/bin/bash

IFACE="wlan0"

if ! ip link show "$IFACE" >/dev/null 2>&1; then
  printf '{"text":"󰤭 OFF","signal":0,"class":"offline"}\n'
  exit
fi

SSID=$(iw dev "$IFACE" link 2>/dev/null | awk -F': ' '/SSID:/ {print $2}')
SIGNAL=$(iw dev "$IFACE" link 2>/dev/null | awk '/signal:/ {print int($2)}')

if [ -z "$SSID" ]; then
  printf '{"text":"󰤭 OFF","signal":0,"class":"offline"}\n'
  exit
fi

if [ -z "$SIGNAL" ]; then
  SIGNAL=0
fi

if [ "$SIGNAL" -lt 0 ]; then
  SIGNAL=$((SIGNAL + 100))
fi

[ "$SIGNAL" -gt 100 ] && SIGNAL=100
[ "$SIGNAL" -lt 0 ] && SIGNAL=0

printf '{"text":"󰤨 %s%%","signal":%s,"tooltip":"Connected: %s\\nSignal: %s%%"}\n' \
  "$SIGNAL" "$SIGNAL" "$SSID" "$SIGNAL"
