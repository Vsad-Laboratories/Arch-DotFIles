#!/usr/bin/env bash
# ============================================================
# Vsad Config Backup Script
# Copies live configs into the single ~/.config/vsad/config/ tree
# for easy documentation and restoration.
# ============================================================

set -euo pipefail

CFG="$HOME/.config/vsad/config"
mkdir -p "$CFG"

backup() {
    local src="$1" dest="$2"
    if [[ -e "$src" ]]; then
        cp -rLf "$src" "$dest"
        echo "  ✓ $src -> $dest"
    else
        echo "  ✗ skipped (missing): $src"
    fi
}

echo "== Backing up dotfiles into $CFG =="

backup "$HOME/.config/i3/config"        "$CFG/i3.conf.bak"
backup "$HOME/.config/kitty/kitty.conf" "$CFG/kitty.conf.bak"
backup "$HOME/.zshrc"                   "$CFG/zshrc.bak"
backup "$HOME/.config/starship.toml"    "$CFG/starship.toml.bak"
backup "$HOME/.config/btop/btop.conf"   "$CFG/btop.conf.bak"
backup "$HOME/.config/fontconfig/fonts.conf" "$CFG/fonts.conf.bak"
backup "$HOME/.config/picom/picom.conf" "$CFG/picom.conf.bak"
backup "$HOME/.config/i3status/config"  "$CFG/i3status.conf.bak"
backup "$HOME/.config/nvim/lazy-lock.json" "$CFG/nvim-lazy-lock.json.bak"

echo "== Done. Restore copies back to their live paths as needed. =="
