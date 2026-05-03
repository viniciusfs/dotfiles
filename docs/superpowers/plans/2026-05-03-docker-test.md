# Docker Test Environment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a local Docker-based test environment that runs `install.sh` in a clean Ubuntu 24.04 container with a non-root user and sudo.

**Architecture:** Two files in `test/`: a `Dockerfile` that builds an Ubuntu 24.04 image with `testuser` + NOPASSWD sudo, and a `run.sh` that builds the image and runs the container with the local repo mounted read-only at the path homeshick expects, plus a named Docker volume for mise tool cache.

**Tech Stack:** Docker, bash, Ubuntu 24.04

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `test/Dockerfile` | Create | Ubuntu 24.04 image with testuser + sudo NOPASSWD |
| `test/run.sh` | Create | Build image + run container with volume mounts |

---

## Task 1: test/Dockerfile

**Files:**
- Create: `test/Dockerfile`

- [ ] **Step 1: Create the test/ directory and Dockerfile**

```bash
mkdir -p test
```

Create `test/Dockerfile` with this exact content:

```dockerfile
FROM ubuntu:24.04

ARG USERNAME=testuser
ARG UID=1000

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      sudo git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -u ${UID} -s /bin/bash ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
```

- [ ] **Step 2: Verify the Dockerfile builds**

```bash
docker build -t dotfiles-test test/
```

Expected: build completes with output ending in:
```
 => exporting to image
 => => naming to docker.io/library/dotfiles-test
```

- [ ] **Step 3: Verify the user and sudo are configured correctly**

```bash
docker run --rm dotfiles-test id
```

Expected output (UID may vary):
```
uid=1000(testuser) gid=1000(testuser) groups=1000(testuser)
```

```bash
docker run --rm dotfiles-test sudo id
```

Expected output:
```
uid=0(root) gid=0(root) groups=0(root)
```

- [ ] **Step 4: Commit**

```bash
git add test/Dockerfile
git commit -m "feat(test): add Dockerfile — Ubuntu 24.04 with testuser and sudo NOPASSWD"
```

---

## Task 2: test/run.sh

**Files:**
- Create: `test/run.sh`

- [ ] **Step 1: Create test/run.sh**

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="dotfiles-test"
CACHE_VOLUME="dotfiles-mise-cache"

docker build -t "$IMAGE" "$REPO_ROOT/test/"

docker run --rm \
  -v "$REPO_ROOT:/home/testuser/.homesick/repos/dotfiles:ro" \
  -v "$CACHE_VOLUME:/home/testuser/.local/share/mise" \
  "$IMAGE" \
  bash -c "cd /home/testuser/.homesick/repos/dotfiles && ./install.sh"
```

- [ ] **Step 2: Make executable and verify syntax**

```bash
chmod +x test/run.sh
bash -n test/run.sh
```

Expected: no output.

- [ ] **Step 3: Verify the volume mount path is correct**

```bash
docker run --rm \
  -v "$(pwd):/home/testuser/.homesick/repos/dotfiles:ro" \
  dotfiles-test \
  ls /home/testuser/.homesick/repos/dotfiles/
```

Expected: lists repo contents including `install.sh`, `scripts/`, `home/`, `docs/`.

- [ ] **Step 4: Commit**

```bash
git add test/run.sh
git commit -m "feat(test): add run.sh — builds image and runs install.sh in container"
```

---

## Task 3: End-to-end smoke test

- [ ] **Step 1: Run the full test**

```bash
./test/run.sh
```

Expected: `install.sh` runs inside the container and prints the installation summary. The run will take 10–30 minutes on first execution (downloads apt packages + all mise tools). Output ends with:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Installation Summary

✓ apt
✓ fonts
✓ homeshick
✓ neovim
✓ rust
✓ mise
✓ tmux
✓ qtile
```

Note: individual modules may show as FAIL on the first run if network is slow or a download fails. Re-run `./test/run.sh` — mise and other tools will use the cache and the run will be much faster.

- [ ] **Step 2: Verify mise cache volume was created**

```bash
docker volume inspect dotfiles-mise-cache
```

Expected: JSON output showing the volume exists with a non-empty `Mountpoint`.

- [ ] **Step 3: Verify second run is fast (uses cache)**

Run again immediately:

```bash
time ./test/run.sh
```

Expected: completes significantly faster than the first run (2–5 minutes vs 10–30 minutes).

- [ ] **Step 4: Update README with test instructions**

Add a `## Testing` section to `README.md`:

```markdown
## Testing

Run the post-install script in a clean Ubuntu 24.04 Docker container:

\`\`\`bash
./test/run.sh
\`\`\`

First run downloads all tools (~2 GB). Subsequent runs reuse the cache and complete in 2–5 minutes.

To clear the mise tool cache:

\`\`\`bash
docker volume rm dotfiles-mise-cache
\`\`\`
```

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: add testing section to README"
```
