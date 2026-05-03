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
