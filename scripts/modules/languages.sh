#!/usr/bin/env bash
# Language Runtimes Installation (Python, Go, Rust)
set -euo pipefail
log_info() { echo -e "\033[0;34m[languages]\033[0m $*"; }
eval "$(~/.local/bin/mise activate bash)"
log_info "Installing Python, Go, Rust..."
mise use -g python@latest go@latest rust@latest
log_info "Installing Python tools (ruff, black)..."
curl -LsSf https://astral.sh/uv/install.sh | sh
~/.uv/bin/uv tool install ruff black
