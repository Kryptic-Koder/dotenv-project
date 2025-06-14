#!/usr/bin/env bash
# Cross-Platform Package Management Wrapper
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/os-detect.sh"
log_info() { echo -e "\033[0;34m[pm]\033[0m $*"; }

install_package_manager_deps() {
    local pm
    pm=$(detect_package_manager)
    if [[ "$pm" == "none" ]]; then
        log_error "No supported package manager found. Please install dependencies manually: $*"
        return 1
    fi
    log_info "Using $pm to install: $*"
    for pkg in "$@"; do
        if ! command -v "$pkg" >/dev/null; then
            case "$pm" in
                brew) brew install "$pkg" ;;
                apt) sudo apt-get install -y "$pkg" ;;
                dnf) sudo dnf install -y "$pkg" ;;
            esac
        fi
    done
}
