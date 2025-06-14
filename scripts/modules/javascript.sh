#!/usr/bin/env bash
# JavaScript Ecosystem Installation
set -euo pipefail
log_info() { echo -e "\033[0;34m[javascript]\033[0m $*"; }
eval "$(~/.local/bin/mise activate bash)"
log_info "Installing Node.js (LTS), Bun, PNPM..."
mise use -g node@lts bun@latest pnpm@latest
log_info "Installing essential npm packages..."
npm install -g typescript prettier eslint_d
