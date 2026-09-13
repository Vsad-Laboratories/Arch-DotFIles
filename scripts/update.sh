#!/usr/bin/env bash

# ============================================================
# VSAD SYSTEM UPDATE
# Arch Linux maintenance utility
# ============================================================

set -uo pipefail

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

HOSTNAME="$(hostname)"
START_TIME="$(date +%s)"

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
# Symbols
# ------------------------------------------------------------

CHECK="✓"
ARROW="▸"
WARN="!"
FAIL="✗"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

header() {
  clear

  printf "\n"
  printf "${PURPLE}${BOLD}"
  printf "╔══════════════════════════════════════════════════════╗\n"
  printf "║                                                      ║\n"
  printf "║                 V S A D   U P D A T E                ║\n"
  printf "║                                                      ║\n"
  printf "║              ARCH LINUX MAINTENANCE                  ║\n"
  printf "║                                                      ║\n"
  printf "╚══════════════════════════════════════════════════════╝\n"
  printf "${RESET}\n"

  printf "  ${GRAY}Host${RESET}    ${WHITE}%s${RESET}\n" "$HOSTNAME"
  printf "  ${GRAY}Kernel${RESET}  ${WHITE}%s${RESET}\n" "$(uname -r)"
  printf "  ${GRAY}Time${RESET}    ${WHITE}%s${RESET}\n" "$(date '+%Y-%m-%d %H:%M:%S')"

  printf "\n"
}

section() {
  printf "\n${PURPLE}${BOLD}%s %s${RESET}\n" "$ARROW" "$1"
}

success() {
  printf "  ${GREEN}${CHECK}${RESET} %s\n" "$1"
}

warning() {
  printf "  ${YELLOW}${WARN}${RESET} %s\n" "$1"
}

failure() {
  printf "  ${RED}${FAIL}${RESET} %s\n" "$1"
}

info() {
  printf "  ${GRAY}•${RESET} %s\n" "$1"
}

# ------------------------------------------------------------
# Pre-flight
# ------------------------------------------------------------

preflight() {
  section "Pre-flight checks"

  if [[ $EUID -eq 0 ]]; then
    failure "Do not run VSAD UPDATE as root."
    info "Run it normally. sudo will be requested by pacman."
    exit 1
  fi

  if ! command -v pacman >/dev/null 2>&1; then
    failure "pacman was not found."
    exit 1
  fi

  success "Pacman detected"
  success "User session verified"
}

# ------------------------------------------------------------
# System update
# ------------------------------------------------------------

update_system() {
  section "System update"

  info "Synchronizing package databases..."
  printf "\n"

  if sudo pacman -Syu; then
    printf "\n"
    success "Official Arch packages are up to date."
  else
    printf "\n"
    failure "System update failed."
    info "No cleanup operations will be performed."
    exit 1
  fi
}

# ------------------------------------------------------------
# Orphan packages
# ------------------------------------------------------------

clean_orphans() {
  section "Orphan package scan"

  local orphan_output
  local -a orphans

  orphan_output="$(pacman -Qdtq 2>/dev/null || true)"

  if [[ -z "$orphan_output" ]]; then
    success "No orphan packages found."
    return
  fi

  mapfile -t orphans <<<"$orphan_output"

  warning "${#orphans[@]} orphan package(s) detected."

  printf "\n"
  for package in "${orphans[@]}"; do
    printf "    ${GRAY}•${RESET} %s\n" "$package"
  done
  printf "\n"

  printf "  ${YELLOW}Remove these orphan packages? [y/N] ${RESET}"
  read -r answer

  case "$answer" in
  y | Y | yes | YES)
    printf "\n"

    if sudo pacman -Rns -- "${orphans[@]}"; then
      success "Orphan packages removed."
    else
      warning "Some orphan packages could not be removed."
    fi
    ;;
  *)
    info "Orphan cleanup skipped."
    ;;
  esac
}

# ------------------------------------------------------------
# Final report
# ------------------------------------------------------------

final_report() {
  local end_time elapsed minutes seconds

  end_time="$(date +%s)"
  elapsed=$((end_time - START_TIME))

  minutes=$((elapsed / 60))
  seconds=$((elapsed % 60))

  printf "\n"
  printf "${PURPLE}${BOLD}"
  printf "╔══════════════════════════════════════════════════════╗\n"
  printf "║                                                      ║\n"
  printf "║              UPDATE COMPLETE                         ║\n"
  printf "║                                                      ║\n"
  printf "╚══════════════════════════════════════════════════════╝\n"
  printf "${RESET}\n"

  printf "  ${GREEN}${CHECK}${RESET} System update completed\n"
  printf "  ${GREEN}${CHECK}${RESET} Package databases synchronized\n"
  printf "  ${GREEN}${CHECK}${RESET} Official packages processed\n"
  printf "  ${GREEN}${CHECK}${RESET} Orphan scan completed\n"

  printf "\n"
  printf "  ${GRAY}Execution time:${RESET} ${WHITE}%02d:%02d${RESET}\n" \
    "$minutes" "$seconds"

  printf "\n"
  printf "${PURPLE}VSAD${RESET} ${GRAY}system maintenance complete.${RESET}\n"
  printf "\n"
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

header

preflight
update_system
clean_orphans
final_report
