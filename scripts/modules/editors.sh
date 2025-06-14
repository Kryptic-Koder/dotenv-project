#!/usr/bin/env bash
# Editor Setup (Neovim)
set -euo pipefail
log_info() { echo -e "\033[0;34m[editors]\033[0m $*"; }
source "$(dirname "${BASH_SOURCE[0]}")/../utils/package-managers.sh"

log_info "Installing Neovim..."
if [[ "$(uname)" == "Darwin" ]]; then
    brew install neovim
else
    # Simple case for Debian-based systems
    sudo apt-get install -y neovim
fi
log_info "Neovim installation complete. Plugins will be installed on first run."
