#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

if command_exists rustup; then
  log_skip "rustup already installed"
  exit 0
fi

log_info "installing rustup (stable toolchain, no PATH modification)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --no-modify-path
log_ok "rustup installed — PATH is managed by .bashrc"
