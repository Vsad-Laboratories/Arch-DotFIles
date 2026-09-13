#!/usr/bin/env bash
# ============================================================
# Vsad Telemetry Snapshot
# Grabs a lightweight system health snapshot into ~/.config/vsad/logs
# for quick review of resource usage, caches, font and locale state.
# ============================================================

set -uo pipefail
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$HOME/.config/vsad/logs/system-$STAMP.txt"
mkdir -p "$(dirname "$OUT")"

{
    echo "=== Vsad System Snapshot: $STAMP ==="
    echo
    echo "--- Uptime / Load ---"
    uptime
    echo
    echo "--- Memory ---"
    free -h
    echo
    echo "--- Disk (root + home) ---"
    df -h / "$HOME" 2>/dev/null
    echo
    echo "--- Top CPU / MEM processes ---"
    ps aux --sort=-%cpu | head -8
    echo
    echo "--- Fonts (should be Maple Mono NF) ---"
    fc-match monospace
    fc-match sans-serif
    echo
    echo "--- Locale ---"
    echo "LANG=$LANG"
    locale 2>/dev/null | head -3
    echo
    echo "--- Cache sizes ---"
    echo "npm:      $(du -sh "$HOME/.npm" 2>/dev/null | cut -f1)"
    echo ".cache:   $(du -sh "$HOME/.cache" 2>/dev/null | cut -f1)"
    echo
    echo "--- Installed toolchain ---"
    command -v kitty && kitty --version
    command -v i3 && i3 --version
    command -v yazi && yazi --version
    command -v btop && btop --version
    command -v nvim && nvim --version | head -1
} > "$OUT"

echo "Snapshot written to: $OUT"
