#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

XSESSION_FILE="/usr/share/xsessions/qtile.desktop"

if ! command_exists qtile; then
  log_info "installing qtile via pipx"
  pipx install qtile
  log_ok "qtile installed"
else
  log_skip "qtile already installed"
fi

if [ ! -f "$XSESSION_FILE" ]; then
  log_info "registering qtile as a display manager session"
  sudo tee "$XSESSION_FILE" > /dev/null <<DESKTOP
[Desktop Entry]
Name=Qtile
Comment=Qtile Window Manager
Exec=$HOME/.local/bin/qtile start
Type=Application
Keywords=wm;tiling
DESKTOP
  log_ok "qtile registered at $XSESSION_FILE"
else
  log_skip "qtile xsession already registered"
fi
