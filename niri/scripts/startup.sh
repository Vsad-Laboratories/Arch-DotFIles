#!/bin/bash
# VSAD Startup — lightweight boot sequence

# Kill existing processes
pkill -f swaybg 2>/dev/null
pkill -f waybar 2>/dev/null
pkill -f mako 2>/dev/null
pkill -f xwayland-satellite 2>/dev/null
pkill -f cliphist 2>/dev/null

sleep 0.3

# Start XWayland (for legacy apps)
xwayland-satellite &

# Start clipboard history daemon
wl-paste --type text/plain --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Start notification daemon
mako &

# Start wallpaper
~/.config/waybar/scripts/wallpaper-init.sh &

# Start waybar
waybar &

# Sync
wait
