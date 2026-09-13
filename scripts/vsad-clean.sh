#!/usr/bin/env bash

# ============================================================
# VSAD CLEAN
# Safe Arch Linux cache + temporary file cleanup
#
# Location:
#   /home/Vsad/vsad-clean
#
# Run:
#   /home/Vsad/vsad-clean
#
# Designed for:
#   Arch Linux • Niri • VSAD
#
# Removes:
#   - Pacman package cache
#   - Unused/orphaned packages
#   - Systemd journal logs older than the retention period
#   - User application caches
#   - Safe temporary files
#
# Does NOT remove:
#   - Personal files
#   - Documents / Downloads / Projects
#   - ~/.config
#   - ~/.local/share
#   - Installed applications
#   - Boot files
#   - System-critical files
#
# ============================================================

set -uo pipefail

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

USER_HOME="/home/Vsad"

# Keep this much journal history.
JOURNAL_RETENTION="7d"

# Cache directories that are safe to recreate.
USER_CACHE="$USER_HOME/.cache"

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

RESET='\033[0m'
BOLD='\033[1m'

PURPLE='\033[38;5;141m'
WHITE='\033[97m'
GRAY='\033[90m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
CYAN='\033[96m'

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

header() {
  clear
  printf "\n"
  printf "${PURPLE}${BOLD}"
  printf "╔══════════════════════════════════════════════════════╗\n"
  printf "║                    VSAD CLEAN                        ║\n"
  printf "║             SYSTEM MAINTENANCE UTILITY               ║\n"
  printf "╚══════════════════════════════════════════════════════╝\n"
  printf "${RESET}\n"
}

section() {
  printf "\n${PURPLE}${BOLD}▸ %s${RESET}\n" "$1"
}

info() {
  printf "  ${GRAY}•${RESET} %s\n" "$1"
}

success() {
  printf "  ${GREEN}✓${RESET} %s\n" "$1"
}

warning() {
  printf "  ${YELLOW}!${RESET} %s\n" "$1"
}

error() {
  printf "  ${RED}✗${RESET} %s\n" "$1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Disk space
# ------------------------------------------------------------

get_free_space() {
  df -B1 "$USER_HOME" 2>/dev/null | awk 'NR==2 {print $4}'
}

format_bytes() {
  local bytes="${1:-0}"

  if ((bytes < 1024)); then
    printf "%d B" "$bytes"
  elif ((bytes < 1024 * 1024)); then
    awk -v b="$bytes" 'BEGIN {printf "%.1f KiB", b/1024}'
  elif ((bytes < 1024 * 1024 * 1024)); then
    awk -v b="$bytes" 'BEGIN {printf "%.1f MiB", b/1024/1024}'
  else
    awk -v b="$bytes" 'BEGIN {printf "%.2f GiB", b/1024/1024/1024}'
  fi
}

# ------------------------------------------------------------
# Safety checks
# ------------------------------------------------------------

safety_check() {
  section "Safety checks"

  if [[ "$USER_HOME" != "/home/Vsad" ]]; then
    error "Unexpected user home path."
    exit 1
  fi

  if [[ ! -d "$USER_HOME" ]]; then
    error "Home directory does not exist: $USER_HOME"
    exit 1
  fi

  if [[ "$(id -u)" -eq 0 ]]; then
    error "Do not run this script directly as root."
    info "Run it normally. It will request sudo only where needed."
    exit 1
  fi

  success "Running as normal user: $(whoami)"
  success "Target home: $USER_HOME"
}

# ------------------------------------------------------------
# Initial disk state
# ------------------------------------------------------------

INITIAL_FREE="$(get_free_space)"

# ------------------------------------------------------------
# Confirmation
# ------------------------------------------------------------

confirm_cleanup() {
  section "Cleanup plan"

  printf "  ${WHITE}The following disposable data may be removed:${RESET}\n\n"

  printf "  ${GRAY}1.${RESET} Pacman package cache\n"
  printf "  ${GRAY}2.${RESET} Orphaned packages\n"
  printf "  ${GRAY}3.${RESET} Systemd journal entries older than ${JOURNAL_RETENTION}\n"
  printf "  ${GRAY}4.${RESET} User application caches in ~/.cache\n"
  printf "  ${GRAY}5.${RESET} Safe temporary files in /tmp\n"

  printf "\n"
  printf "  ${YELLOW}Personal files, configs, projects and installed applications\n"
  printf "  will NOT be deleted.${RESET}\n"

  printf "\n${PURPLE}Continue? [y/N] ${RESET}"
  read -r answer

  case "$answer" in
  y | Y | yes | YES)
    ;;
  *)
    printf "\n${GRAY}Cleanup cancelled.${RESET}\n\n"
    exit 0
    ;;
  esac
}

# ------------------------------------------------------------
# Pacman cache
# ------------------------------------------------------------

clean_pacman_cache() {
  section "Pacman package cache"

  if ! command_exists pacman; then
    warning "pacman was not found. Skipping."
    return
  fi

  if command_exists paccache; then
    info "Keeping the 3 most recent versions of installed packages."
    sudo paccache -rk3

    info "Removing cached packages that are no longer installed."
    sudo paccache -ruk0

    success "Pacman cache cleaned safely."
  else
    warning "paccache is not installed."
    info "Skipping aggressive cache deletion."
    info "Install pacman-contrib later if you want paccache support."
  fi
}

# ------------------------------------------------------------
# Orphan packages
# ------------------------------------------------------------

clean_orphans() {
  section "Orphaned packages"

  if ! command_exists pacman; then
    warning "pacman was not found. Skipping."
    return
  fi

  local orphans
  orphans="$(pacman -Qtdq 2>/dev/null || true)"

  if [[ -z "$orphans" ]]; then
    success "No orphaned packages found."
    return
  fi

  printf "\n${YELLOW}The following orphaned packages were detected:${RESET}\n\n"
  printf "%s\n" "$orphans"
  printf "\n"

  printf "${PURPLE}Remove these orphaned packages? [y/N] ${RESET}"
  read -r answer

  case "$answer" in
  y | Y | yes | YES)
    if sudo pacman -Rns -- "$orphans"; then
      success "Orphaned packages removed."
    else
      warning "Pacman could not remove all orphaned packages."
    fi
    ;;
  *)
    info "Orphan removal skipped."
    ;;
  esac
}

# ------------------------------------------------------------
# Systemd journal
# ------------------------------------------------------------

clean_journal() {
  section "Systemd journal"

  if ! command_exists journalctl; then
    warning "journalctl was not found. Skipping."
    return
  fi

  info "Removing journal entries older than ${JOURNAL_RETENTION}."

  if sudo journalctl --vacuum-time="$JOURNAL_RETENTION"; then
    success "Old journal entries removed."
  else
    warning "Journal cleanup failed."
  fi
}

# ------------------------------------------------------------
# User cache
# ------------------------------------------------------------

clean_user_cache() {
  section "User application cache"

  if [[ ! -d "$USER_CACHE" ]]; then
    success "~/.cache does not exist."
    return
  fi

  local before after removed

  before="$(du -sb "$USER_CACHE" 2>/dev/null | awk '{print $1}')"

  info "Cleaning disposable contents of ~/.cache."

  # Remove contents, not the cache directory itself.
  #
  # Applications recreate these directories automatically.
  #
  # The glob is intentionally restricted to ~/.cache.
  find "$USER_CACHE" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + 2>/dev/null || true

  after="$(du -sb "$USER_CACHE" 2>/dev/null | awk '{print $1}')"

  before="${before:-0}"
  after="${after:-0}"

  if ((before > after)); then
    removed=$((before - after))
    success "Freed $(format_bytes "$removed") from ~/.cache."
  else
    info "No removable user cache data found."
  fi
}

# ------------------------------------------------------------
# Temporary files
# ------------------------------------------------------------

clean_tmp() {
  section "Temporary files"

  info "Removing files from /tmp that are older than 7 days."

  if sudo find /tmp -xdev -mindepth 1 -mtime +7 -delete 2>/dev/null; then
    success "Old temporary files cleaned."
  else
    warning "Some temporary files could not be removed."
    info "This is normal when files are currently in use."
  fi
}

# ------------------------------------------------------------
# Failed systemd units
# ------------------------------------------------------------

check_failed_units() {
  section "System health check"

  if ! command_exists systemctl; then
    warning "systemctl was not found."
    return
  fi

  local failed
  failed="$(systemctl --failed --no-legend --plain 2>/dev/null || true)"

  if [[ -z "$failed" ]]; then
    success "No failed systemd units."
  else
    warning "Failed systemd units detected:"
    printf "\n%s\n\n" "$failed"
    info "No failed units were automatically modified."
  fi
}

# ------------------------------------------------------------
# Final disk state
# ------------------------------------------------------------

final_report() {
  local final_free reclaimed

  final_free="$(get_free_space)"

  if [[ "$INITIAL_FREE" =~ ^[0-9]+$ ]] &&
    [[ "$final_free" =~ ^[0-9]+$ ]] &&
    ((final_free >= INITIAL_FREE)); then
    reclaimed=$((final_free - INITIAL_FREE))
  else
    reclaimed=0
  fi

  printf "\n"
  printf "${PURPLE}${BOLD}"
  printf "╔══════════════════════════════════════════════════════╗\n"
  printf "║                  CLEANUP COMPLETE                    ║\n"
  printf "╚══════════════════════════════════════════════════════╝\n"
  printf "${RESET}\n"

  printf "  ${CYAN}Free space now:${RESET}  %s\n" \
    "$(format_bytes "$final_free")"

  printf "  ${GREEN}Recovered:${RESET}       %s\n" \
    "$(format_bytes "$reclaimed")"

  printf "\n"
  printf "${GRAY}VSAD CLEAN finished safely.${RESET}\n\n"
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

header
safety_check

printf "\n"
printf "${GRAY}Scanning system...${RESET}\n"

confirm_cleanup

clean_pacman_cache
clean_orphans
clean_journal
clean_user_cache
clean_tmp
check_failed_units

final_report
