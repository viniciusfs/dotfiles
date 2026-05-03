# Post-Install Script Design

**Date:** 2026-05-03
**Scope:** Full Ubuntu Desktop setup — window manager, dev tools, fonts, terminals

## Context

Script runs after the user manually clones the dotfiles repo **to `~/.homesick/repos/dotfiles/`** and runs `./install.sh` from within it. Ubuntu Desktop (GNOME) is already installed. The script customizes the environment by installing all required tooling and linking dotfiles via homeshick.

Prerequisites:
```bash
mkdir -p ~/.homesick/repos
git clone <dotfiles-repo-url> ~/.homesick/repos/dotfiles
cd ~/.homesick/repos/dotfiles
./install.sh
```

## Goals

- Automate the full environment setup from a stock Ubuntu Desktop install
- Be idempotent: safe to run multiple times, skips what is already installed
- Be fully automated: no interactive prompts, assumes all defaults
- Report clearly what was installed, skipped, or failed

## Non-Goals

- Installing Ubuntu itself or configuring the OS installer
- Managing dotfiles after initial link (that is homeshick's job)
- Installing GUI apps not referenced in dotfiles (browsers, etc.)

---

## File Structure

```
dotfiles/
├── install.sh              # entrypoint
└── scripts/
    ├── utils.sh            # shared helpers
    ├── apt.sh              # system packages
    ├── fonts.sh            # Ubuntu Mono Nerd Font
    ├── homeshick.sh        # homeshick install + dotfiles link
    ├── neovim.sh           # neovim binary to /opt/
    ├── rust.sh             # rustup
    ├── mise.sh             # mise + mise install
    ├── tmux.sh             # tmux + tpm
    └── qtile.sh            # qtile via pipx + xsession registration
```

---

## Execution Order

`install.sh` runs modules in this sequence:

1. `apt.sh` — system base must come first; all other installers depend on curl, git, build-essential
2. `fonts.sh` — fonts before any UI config takes effect
3. `homeshick.sh` — links all dotfiles early so subsequent modules find their configs (mise.toml, .tool-versions, etc.)
4. `neovim.sh`
5. `rust.sh`
6. `mise.sh` — runs after apt (needs build-essential, curl) and after homeshick (needs .tool-versions linked)
7. `tmux.sh`
8. `qtile.sh` — last; everything must be in place before registering the session

Each module is sourced in an isolated subshell so a failure in one does not abort the others.

---

## Module Specifications

### utils.sh

Sourced by all other modules. Provides:

- `log_info`, `log_ok`, `log_skip`, `log_warn`, `log_error` — colored output via `tput` with graceful fallback
- `command_exists <cmd>` — returns 0 if command is in PATH
- `MODULE_STATUS` variable written by each module (`ok`, `skip`, `fail`) for the final summary

### apt.sh

Runs `apt-get update` then installs packages grouped by purpose.

Idempotency: `dpkg -s <pkg>` check before each group; skips the group if all packages are already installed.

Package groups:

| Group | Packages |
|---|---|
| Base | `git curl wget build-essential pkg-config libssl-dev ca-certificates` |
| Desktop | `picom rofi dunst x11-utils xrandr setxkbmap scrot` |
| Terminals | `kitty alacritty` |
| System tray | `network-manager-gnome blueman pasystray` |
| Audio | `pulseaudio-utils` |
| Dev tools | `ripgrep fd-find python3-psutil python3-pip pipx` |

After installing `fd-find`, apt.sh creates a symlink so the binary is available as `fd` (Ubuntu ships it as `fdfind`):
```bash
ln -sf /usr/bin/fdfind ~/.local/bin/fd
```
| Misc | `xclip im-config tmux` |

### fonts.sh

Downloads Ubuntu Mono Nerd Font from the nerd-fonts GitHub releases into `~/.local/share/fonts/`, then runs `fc-cache -fv`.

Idempotency: `fc-list | grep -qi "Ubuntu Mono Nerd"` — skips if font is already registered.

### homeshick.sh

1. Clones `https://github.com/andsens/homeshick.git` into `~/.homesick/repos/homeshick` if the directory does not exist.
2. Runs `~/.homesick/repos/homeshick/bin/homeshick link dotfiles --force` to create all symlinks.

Idempotency: directory check for `~/.homesick/repos/homeshick`.

### neovim.sh

Downloads the latest stable `nvim-linux-x86_64.tar.gz` from GitHub releases, extracts to `/opt/`, makes binary executable.

Idempotency: `test -f /opt/nvim-linux-x86_64/bin/nvim`.

The version is pinned via a variable at the top of the script for reproducibility.

### rust.sh

Installs rustup with:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
```

`--no-modify-path` is used because PATH management is handled by `.bashrc` in the dotfiles.

Idempotency: `command_exists rustup`.

### mise.sh

1. Installs mise via `curl https://mise.run | sh`
2. Adds asdf plugins that are not in the aqua registry and require explicit registration:
   - `mise plugin add argo-rollouts`
   - `mise plugin add argocd`
   - `mise plugin add crossplane-cli`
   - `mise plugin add kuttl`
3. Runs `~/.local/bin/mise install` which reads `~/.tool-versions` (already linked by homeshick)

Idempotency: `command_exists mise` for step 1; each `mise plugin add` is skipped if the plugin already exists; `mise install` is itself idempotent (skips installed versions).

### tmux.sh

1. Verifies `tmux` is installed (installed by apt.sh)
2. Clones tpm into `~/.tmux/plugins/tpm` if not present

Plugins are installed by tpm on first tmux use — no extra step needed in the script.

Idempotency: `test -d ~/.tmux/plugins/tpm`.

### qtile.sh

1. Installs qtile via `pipx install qtile` (gets current version, not the stale apt package)
2. Creates `/usr/share/xsessions/qtile.desktop` so GDM/LightDM lists qtile as a session option

The `.desktop` file content:
```ini
[Desktop Entry]
Name=Qtile
Comment=Qtile Window Manager
Exec=qtile start
Type=Application
```

Idempotency:
- `command_exists qtile` for pipx install
- `test -f /usr/share/xsessions/qtile.desktop` for the session file (requires sudo)

---

## Idempotency Strategy

| Install type | Check |
|---|---|
| Binary in PATH | `command_exists <cmd>` |
| Specific file | `test -f <path>` |
| Directory | `test -d <path>` |
| apt package | `dpkg -s <pkg> &>/dev/null` |
| Font | `fc-list \| grep -qi "Ubuntu Mono Nerd"` |

---

## Error Handling

- Each module runs in an isolated subshell in `install.sh`
- Each module sets exit code 0 (ok/skip) or 1 (fail)
- `install.sh` collects results and prints a final summary:

```
[OK]   apt packages
[OK]   fonts
[SKIP] neovim (already installed)
[FAIL] mise — see output above
[OK]   tmux
[OK]   qtile
```

- No `set -e` globally — partial failures do not abort the run

---

## sudo Requirements

Modules that need sudo:
- `apt.sh` — package installation
- `qtile.sh` — writing to `/usr/share/xsessions/`

The script does not cache sudo credentials globally. Each module that needs sudo calls it inline. If the session times out between modules, sudo will prompt again (this is the only exception to the "no interactive prompts" rule, as it is a system security constraint).

---

## What the Script Does NOT Do

- Set qtile as the default session (user selects it at login screen)
- Install browser or other GUI apps
- Configure any secrets, SSH keys, or credentials
- Install neovim plugins (lazy.nvim bootstraps itself on first `nvim` launch)
- Install tmux plugins (tpm installs them on first tmux use via prefix+I)
