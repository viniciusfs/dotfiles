# Docker Test Environment Design

**Date:** 2026-05-03
**Scope:** Local Docker-based testing of the post-install script against a fresh Ubuntu 24.04 container

## Context

The post-install script (`install.sh` + `scripts/`) installs a full Ubuntu developer environment. This spec covers a Docker-based test environment that runs the script against a clean Ubuntu 24.04 image with a non-root user and sudo, matching the real install scenario as closely as possible without a display.

## Goals

- Run `install.sh` in a clean Ubuntu 24.04 environment with a single command
- Test as a regular user with sudo (not root) — matches real install scenario
- Mount the local repo so changes are testable without pushing
- Cache mise tool downloads between runs to avoid re-downloading ~2 GB every time
- Success criterion: `install.sh` exits with code 0 and the summary is printed

Note: `install.sh` is designed to always exit 0 (module failures show in the summary but don't abort). A non-zero exit from `run.sh` means the Docker infrastructure itself failed, not a module failure. Module-level failures are visible only in the printed summary.

## Non-Goals

- Testing GUI modules (qtile session at login screen, picom compositor, display manager)
- Assertions beyond exit code (no binary existence checks, no output parsing)
- CI integration (that is a separate concern)
- KVM/VM testing (separate spec)

---

## File Structure

```
dotfiles/
└── test/
    ├── Dockerfile    # Ubuntu 24.04 image with testuser + sudo NOPASSWD
    └── run.sh        # build image, run container with volume mounts
```

---

## Dockerfile

Base image: `ubuntu:24.04`

Installs only the minimum bootstrap dependencies — everything else is the responsibility of `apt.sh`:
- `sudo` — required by apt.sh, neovim.sh, qtile.sh
- `git` — required by homeshick.sh, tmux.sh
- `curl` — required by fonts.sh, rust.sh, mise.sh
- `ca-certificates` — required for HTTPS downloads

Creates user `testuser` (UID 1000) with:
- Home directory at `/home/testuser`
- `/bin/bash` shell
- `NOPASSWD:ALL` sudo rule (no password prompts during script execution)

Switches to `testuser` before the entrypoint. The container never runs as root.

`WORKDIR` is set to `/home/testuser`.

Build args:
- `USERNAME` (default: `testuser`)
- `UID` (default: `1000`)

---

## run.sh

Standalone script at `test/run.sh`. Executable, runs from any directory.

**Steps:**
1. Resolves `REPO_ROOT` as the parent of `test/` (works regardless of invocation path)
2. Builds Docker image tagged `dotfiles-test` from `test/Dockerfile`; build cache means this is fast on subsequent runs if the Dockerfile has not changed
3. Runs a container with:
   - `--rm` — container removed after exit
   - `-v "$REPO_ROOT:/home/testuser/.homesick/repos/dotfiles:ro"` — local repo mounted read-only at the path homeshick expects
   - `-v "dotfiles-mise-cache:/home/testuser/.local/share/mise"` — named volume for mise tool cache, persists between runs
   - Command: `bash -c "cd /home/testuser/.homesick/repos/dotfiles && ./install.sh"`

Exit code of `run.sh` equals exit code of `docker run`, which equals exit code of `install.sh`.

**Cache management:**

The named volume `dotfiles-mise-cache` accumulates downloaded tool binaries (~2 GB for the full `.tool-versions`). To force a clean download:

```bash
docker volume rm dotfiles-mise-cache
```

---

## Volume Mount Detail

The repo is mounted at `/home/testuser/.homesick/repos/dotfiles` — the exact path that `homeshick link dotfiles` expects. This means:

- `homeshick.sh` skips the clone step (homeshick itself still gets cloned to `~/.homesick/repos/homeshick` inside the container)
- `homeshick link dotfiles --force` runs against the mounted repo and creates symlinks inside the container's home
- Dotfiles on the host are never modified (`:ro` mount)

---

## Modules Covered

| Module | Works in Docker | Notes |
|---|---|---|
| apt.sh | ✅ | Full package install |
| fonts.sh | ✅ | Downloads + fc-cache |
| homeshick.sh | ✅ | Repo pre-mounted |
| neovim.sh | ✅ | Downloads to /opt/ |
| rust.sh | ✅ | rustup install |
| mise.sh | ✅ | Downloads all tools (cached) |
| tmux.sh | ✅ | Clones tpm |
| qtile.sh | ⚠️ | pipx install works; xsession .desktop written; no display to verify login |

`qtile.sh` completes without error but the xsession registration is untestable without a display manager. This is accepted scope for Docker testing.

---

## Usage

```bash
cd ~/.homesick/repos/dotfiles
./test/run.sh
```

First run: 10–30 minutes (apt + all mise tools downloaded).
Subsequent runs: 2–5 minutes (Docker layer cache + mise tool cache).
