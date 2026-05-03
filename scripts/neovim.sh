#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

NVIM_VERSION="v0.11.5"
NVIM_TARBALL="/tmp/nvim-linux-x86_64.tar.gz"
NVIM_BINARY="/opt/nvim-linux-x86_64/bin/nvim"

if [ -f "$NVIM_BINARY" ]; then
  log_skip "neovim already installed at $NVIM_BINARY"
  exit 0
fi

log_info "downloading neovim $NVIM_VERSION"
curl -fsSL \
  "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
  -o "$NVIM_TARBALL"

log_info "extracting to /opt/"
sudo tar -C /opt -xzf "$NVIM_TARBALL"
rm -f "$NVIM_TARBALL"

log_ok "neovim $NVIM_VERSION installed to /opt/nvim-linux-x86_64"
