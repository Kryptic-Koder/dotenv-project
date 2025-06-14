#!/usr/bin/env bash
# Container Tools Setup (Docker)
set -euo pipefail
log_info() { echo -e "\033[0;34m[containers]\033[0m $*"; }

log_info "Docker installation must be handled manually due to system dependencies."
log_info "Please follow the official guide for your OS: https://docs.docker.com/engine/install/"
