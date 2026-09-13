#!/usr/bin/env bash
# ============================================================
# Vsad System Maintenance
# Cleans caches, temp files, and orphan packages.
# NOTE: root-level commands require the root password via su.
# ============================================================

set -euo pipefail
echo "== Vsad Maintenance =="

# --- User caches ---
echo "[1/4] Cleaning user caches..."
npm cache clean --force 2>/dev/null || true
rm -rf "$HOME/.cache/go-build" 2>/dev/null || true
rm -rf "$HOME/.cache/yay"/*/src "$HOME/.cache/yay"/*/pkg 2>/dev/null || true
echo "  done: $HOME/.cache is $(du -sh "$HOME/.cache" 2>/dev/null | cut -f1)"

# --- Temp ---
echo "[2/4] Cleaning /tmp..."
rm -rf /tmp/* 2>/dev/null || true
echo "  done"

# --- Pacman cache & orphans (root) ---
echo "[3/4] Pacman cache & orphans (needs root)..."
read -rsp "Root password: " pw
echo
printf '%s\n' "$pw" | su -c "pacman -Scc --noconfirm; pacman -Qtdq | pacman -Rns --noconfirm -" root 2>/dev/null || echo "  skipped (password rejected)"
unset pw

echo "[4/4] Old logs..."
journalctl --vacuum-time=7d 2>/dev/null || true

echo "== Maintenance complete =="
