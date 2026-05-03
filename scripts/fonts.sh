#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
FONT_ZIP="/tmp/UbuntuMono.zip"

if fc-list | grep -qi "Ubuntu Mono Nerd"; then
  log_skip "Ubuntu Mono Nerd Font already installed"
  exit 0
fi

log_info "downloading Ubuntu Mono Nerd Font"
mkdir -p "$FONT_DIR"
curl -fsSL \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip" \
  -o "$FONT_ZIP"

log_info "extracting font"
unzip -q -o "$FONT_ZIP" -d "$FONT_DIR"
rm -f "$FONT_ZIP"

log_info "refreshing font cache"
fc-cache -fv &>/dev/null

log_ok "Ubuntu Mono Nerd Font installed"
