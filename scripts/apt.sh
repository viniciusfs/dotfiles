#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

APT_PACKAGES=(
  # Base build tools
  git curl wget build-essential pkg-config libssl-dev ca-certificates
  # Desktop / compositor
  picom rofi dunst x11-utils x11-xserver-utils x11-xkb-utils scrot
  # Terminal emulators
  kitty alacritty
  # System tray applets
  network-manager-gnome blueman pasystray
  # Audio control
  pulseaudio-utils
  # Dev tools
  ripgrep fd-find python3-psutil python3-pip pipx
  # Fonts / file tools
  fontconfig unzip
  # Misc
  xclip im-config tmux
)

to_install=()
for pkg in "${APT_PACKAGES[@]}"; do
  dpkg -s "$pkg" &>/dev/null || to_install+=("$pkg")
done

if [ ${#to_install[@]} -eq 0 ]; then
  log_skip "all apt packages already installed"
else
  log_info "installing ${#to_install[@]} package(s): ${to_install[*]}"
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${to_install[@]}"
  log_ok "apt packages installed"
fi

# Ubuntu ships fd-find as 'fdfind'; create 'fd' symlink for neovim/telescope
if ! command_exists fd && [ -f /usr/bin/fdfind ]; then
  mkdir -p "$HOME/.local/bin"
  ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"
  log_ok "fd symlink created at ~/.local/bin/fd"
elif command_exists fd; then
  log_skip "fd already available"
fi
