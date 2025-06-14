#!/usr/bin/env bash
# OS and Package Manager Detection Utility
set -euo pipefail

detect_os() {
    case "$(uname -s)" in
        Darwin)  echo "macos" ;;
        Linux)   echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

detect_package_manager() {
    local os=$(detect_os)
    if [[ "$os" == "macos" ]]; then
        command -v brew >/dev/null && echo "brew" || echo "none"
    elif [[ "$os" == "linux" ]]; then
        command -v apt-get >/dev/null && echo "apt" || \
        command -v dnf >/dev/null && echo "dnf" || \
        echo "none"
    else
        echo "none"
    fi
}
