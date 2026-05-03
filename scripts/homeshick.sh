#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

HOMESHICK_DIR="$HOME/.homesick/repos/homeshick"
HOMESHICK_BIN="$HOMESHICK_DIR/bin/homeshick"

if [ ! -d "$HOMESHICK_DIR" ]; then
  log_info "cloning homeshick"
  git clone https://github.com/andsens/homeshick.git "$HOMESHICK_DIR"
  log_ok "homeshick cloned"
else
  log_skip "homeshick already installed"
fi

log_info "linking dotfiles (--force overwrites existing plain files)"
"$HOMESHICK_BIN" link dotfiles --force
log_ok "dotfiles linked"
