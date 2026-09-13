#!/bin/bash

CPU=$(awk -v FS=' ' '
    /cpu / {
        idle=$5
        total=$2+$3+$4+$5+$6+$7+$8+$9
        print 100 * (1 - idle / total)
    }
' /proc/stat | head -n1)

CPU=${CPU%.*}

RAM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')

SSD=$(df -P / | awk 'NR==2 {gsub("%",""); print $5}')

TEMP="N/A"

for zone in /sys/class/thermal/thermal_zone*/temp; do
  if [ -r "$zone" ]; then
    value=$(cat "$zone")

    if [ "$value" -gt 1000 ]; then
      TEMP=$((value / 1000))
      break
    fi
  fi
done

printf '{"text":"◉","tooltip":"CPU: %s%%\\nRAM: %s%%\\nSSD: %s%%\\nTEMP: %s°C"}\n' \
  "$CPU" "$RAM" "$SSD" "$TEMP"
