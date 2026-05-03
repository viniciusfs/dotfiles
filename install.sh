#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/utils.sh
source "$SCRIPT_DIR/scripts/utils.sh"

MODULES=(apt fonts homeshick neovim rust mise tmux qtile)
declare -A RESULTS

echo ""
log_info "Starting post-install setup"
echo ""

for module in "${MODULES[@]}"; do
  printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  log_info "[$module]"
  echo ""
  if bash "$SCRIPT_DIR/scripts/${module}.sh"; then
    RESULTS[$module]="OK"
  else
    RESULTS[$module]="FAIL"
  fi
  echo ""
done

printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
echo ""
echo "  Installation Summary"
echo ""
for module in "${MODULES[@]}"; do
  case "${RESULTS[$module]}" in
    OK)   log_ok    "$module" ;;
    FAIL) log_error "$module" ;;
  esac
done
echo ""
