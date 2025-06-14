#!/usr/bin/env bash
# mise universal tool manager setup
set -euo pipefail
log_info() { echo -e "\033[0;34m[mise]\033[0m $*"; }
log_success() { echo -e "\033[0;32m✓\033[0m $*"; }

if command -v mise &>/dev/null; then
    log_info "mise is already installed. Skipping."
    exit 0
fi

log_info "Installing mise..."
curl https://mise.run | sh
log_success "mise installed."
