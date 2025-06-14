#!/usr/bin/env bash
# Installation Validation Script
set -euo pipefail
log_success() { echo -e "\033[0;32m✓\033[0m $*"; }
log_error() { echo -e "\033[0;31m✗\033[0m $*"; }

check_command() {
    if command -v "$1" &>/dev/null; then
        log_success "$1 is installed ($(command -v $1))"
    else
        log_error "$1 is NOT installed."
    fi
}

log_info "--- Running Validation ---"
check_command "zsh"
check_command "nvim"
check_command "mise"
check_command "node"
check_command "python"
check_command "go"
check_command "rustc"
check_command "exa"
check_command "bat"
log_info "--- Validation Complete ---"
