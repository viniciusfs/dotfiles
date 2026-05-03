# Post-Install Script Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a modular, idempotent shell script that fully configures a fresh Ubuntu Desktop install with qtile, dev tools, fonts, terminals, and all dotfiles dependencies.

**Architecture:** An `install.sh` entrypoint runs each module in `scripts/` as an independent subprocess; failures in one module do not abort others. Each module sources `scripts/utils.sh` for shared logging helpers. Idempotency is enforced per-module via existence checks before every install action.

**Tech Stack:** bash, apt, pipx, mise, rustup, curl, git

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `scripts/utils.sh` | Create | Logging helpers, `command_exists` |
| `scripts/apt.sh` | Create | System packages + fd symlink |
| `scripts/fonts.sh` | Create | Ubuntu Mono Nerd Font |
| `scripts/homeshick.sh` | Create | Homeshick install + dotfiles link |
| `scripts/neovim.sh` | Create | Neovim binary to /opt/ |
| `scripts/rust.sh` | Create | Rustup install |
| `scripts/mise.sh` | Create | Mise install + plugins + mise install |
| `scripts/tmux.sh` | Create | TPM clone |
| `scripts/qtile.sh` | Create | Qtile via pipx + xsession registration |
| `install.sh` | Create | Entrypoint, module orchestration, summary |

---

## Task 1: scripts/utils.sh — shared helpers

**Files:**
- Create: `scripts/utils.sh`

- [ ] **Step 1: Create the scripts/ directory and utils.sh**

```bash
mkdir -p scripts
```

Create `scripts/utils.sh` with this exact content:

```bash
#!/usr/bin/env bash

if [ -t 1 ]; then
  _RED=$(tput setaf 1 2>/dev/null || true)
  _GREEN=$(tput setaf 2 2>/dev/null || true)
  _YELLOW=$(tput setaf 3 2>/dev/null || true)
  _CYAN=$(tput setaf 6 2>/dev/null || true)
  _GRAY=$(tput setaf 8 2>/dev/null || true)
  _RESET=$(tput sgr0 2>/dev/null || true)
  _BOLD=$(tput bold 2>/dev/null || true)
else
  _RED=""; _GREEN=""; _YELLOW=""; _CYAN=""; _GRAY=""; _RESET=""; _BOLD=""
fi

log_info()  { printf "%s→%s %s\n" "$_CYAN" "$_RESET" "$*"; }
log_ok()    { printf "%s%s✓%s %s\n" "$_GREEN" "$_BOLD" "$_RESET" "$*"; }
log_skip()  { printf "%s- %s%s\n" "$_GRAY" "$*" "$_RESET"; }
log_warn()  { printf "%s!%s %s\n" "$_YELLOW" "$_RESET" "$*"; }
log_error() { printf "%s%s✗%s %s\n" "$_RED" "$_BOLD" "$_RESET" "$*" >&2; }

command_exists() { command -v "$1" &>/dev/null; }
```

- [ ] **Step 2: Verify syntax**

```bash
bash -n scripts/utils.sh
```

Expected: no output (syntax OK).

- [ ] **Step 3: Commit**

```bash
git add scripts/utils.sh
git commit -m "feat(install): add utils.sh with logging helpers"
```

---

## Task 2: scripts/apt.sh — system packages

**Files:**
- Create: `scripts/apt.sh`

- [ ] **Step 1: Create scripts/apt.sh**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

APT_PACKAGES=(
  # Base build tools
  git curl wget build-essential pkg-config libssl-dev ca-certificates
  # Desktop / compositor
  picom rofi dunst x11-utils xrandr setxkbmap scrot
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/apt.sh
bash -n scripts/apt.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/apt.sh
git commit -m "feat(install): add apt.sh for system packages"
```

---

## Task 3: scripts/fonts.sh — Ubuntu Mono Nerd Font

**Files:**
- Create: `scripts/fonts.sh`

- [ ] **Step 1: Create scripts/fonts.sh**

```bash
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/fonts.sh
bash -n scripts/fonts.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/fonts.sh
git commit -m "feat(install): add fonts.sh for Ubuntu Mono Nerd Font"
```

---

## Task 4: scripts/homeshick.sh — dotfiles linking

**Files:**
- Create: `scripts/homeshick.sh`

- [ ] **Step 1: Create scripts/homeshick.sh**

```bash
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/homeshick.sh
bash -n scripts/homeshick.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/homeshick.sh
git commit -m "feat(install): add homeshick.sh for dotfiles linking"
```

---

## Task 5: scripts/neovim.sh — neovim binary

**Files:**
- Create: `scripts/neovim.sh`

- [ ] **Step 1: Create scripts/neovim.sh**

```bash
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/neovim.sh
bash -n scripts/neovim.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/neovim.sh
git commit -m "feat(install): add neovim.sh — pins v0.11.5"
```

---

## Task 6: scripts/rust.sh — rustup

**Files:**
- Create: `scripts/rust.sh`

- [ ] **Step 1: Create scripts/rust.sh**

```bash
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/rust.sh
bash -n scripts/rust.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/rust.sh
git commit -m "feat(install): add rust.sh for rustup"
```

---

## Task 7: scripts/mise.sh — tool version manager

**Files:**
- Create: `scripts/mise.sh`

- [ ] **Step 1: Create scripts/mise.sh**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

MISE_BIN="$HOME/.local/bin/mise"

# Check by absolute path — PATH may not include ~/.local/bin in a script subshell
if [ ! -x "$MISE_BIN" ]; then
  log_info "installing mise"
  curl https://mise.run | sh
  log_ok "mise installed"
else
  log_skip "mise already installed"
fi

# These tools are not in the aqua registry and require explicit plugin registration
EXTRA_PLUGINS=(argo-rollouts argocd crossplane-cli kuttl)
for plugin in "${EXTRA_PLUGINS[@]}"; do
  if "$MISE_BIN" plugin list | grep -q "^${plugin}$"; then
    log_skip "mise plugin already added: $plugin"
  else
    log_info "adding mise plugin: $plugin"
    "$MISE_BIN" plugin add "$plugin" \
      || log_warn "could not add plugin $plugin — it will be skipped during install"
  fi
done

log_info "running mise install (reads ~/.tool-versions)"
"$MISE_BIN" install
log_ok "mise tools installed"
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/mise.sh
bash -n scripts/mise.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/mise.sh
git commit -m "feat(install): add mise.sh — installs mise + all .tool-versions entries"
```

---

## Task 8: scripts/tmux.sh — TPM

**Files:**
- Create: `scripts/tmux.sh`

- [ ] **Step 1: Create scripts/tmux.sh**

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
  log_skip "tpm already installed"
  exit 0
fi

log_info "cloning tpm"
mkdir -p "$HOME/.tmux/plugins"
git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
log_ok "tpm installed — run prefix+I inside tmux to install plugins"
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/tmux.sh
bash -n scripts/tmux.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/tmux.sh
git commit -m "feat(install): add tmux.sh for tpm"
```

---

## Task 9: scripts/qtile.sh — window manager

**Files:**
- Create: `scripts/qtile.sh`

- [ ] **Step 1: Create scripts/qtile.sh**

```bash
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
  sudo tee "$XSESSION_FILE" > /dev/null <<'DESKTOP'
[Desktop Entry]
Name=Qtile
Comment=Qtile Window Manager
Exec=qtile start
Type=Application
Keywords=wm;tiling
DESKTOP
  log_ok "qtile registered at $XSESSION_FILE"
else
  log_skip "qtile xsession already registered"
fi
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x scripts/qtile.sh
bash -n scripts/qtile.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add scripts/qtile.sh
git commit -m "feat(install): add qtile.sh — installs qtile and registers xsession"
```

---

## Task 10: install.sh — entrypoint

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Create install.sh**

```bash
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
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x install.sh
bash -n install.sh
```

Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add install.sh
git commit -m "feat(install): add install.sh entrypoint with module summary"
```

---

## Task 11: Smoke test — dry syntax pass on all scripts

- [ ] **Step 1: Syntax-check all scripts at once**

```bash
for f in install.sh scripts/*.sh; do
  bash -n "$f" && echo "OK: $f" || echo "FAIL: $f"
done
```

Expected output:
```
OK: install.sh
OK: scripts/apt.sh
OK: scripts/fonts.sh
OK: scripts/homeshick.sh
OK: scripts/mise.sh
OK: scripts/neovim.sh
OK: scripts/qtile.sh
OK: scripts/rust.sh
OK: scripts/tmux.sh
OK: scripts/utils.sh
```

- [ ] **Step 2: Verify all scripts are executable**

```bash
ls -la install.sh scripts/*.sh | awk '{print $1, $9}' | grep -v '^-rwx'
```

Expected: no output (all files are executable).

- [ ] **Step 3: Commit if any chmod was needed**

If any files were not executable and you fixed them:
```bash
git add install.sh scripts/
git commit -m "chore(install): ensure all scripts are executable"
```

---

## Prerequisites (README note)

The repo must be cloned to the exact path `~/.homesick/repos/dotfiles/` for `homeshick link dotfiles` to work:

```bash
mkdir -p ~/.homesick/repos
git clone <repo-url> ~/.homesick/repos/dotfiles
cd ~/.homesick/repos/dotfiles
./install.sh
```
