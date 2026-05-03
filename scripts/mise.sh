#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

MISE_BIN="$HOME/.local/bin/mise"

# Check by absolute path — PATH may not include ~/.local/bin in a script subshell
if [ ! -x "$MISE_BIN" ]; then
  log_info "installing mise"
  curl --proto '=https' --tlsv1.2 -sSf https://mise.run | sh
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
