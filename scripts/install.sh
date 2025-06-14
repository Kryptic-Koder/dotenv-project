#!/usr/bin/env bash
# Main Dotfiles Installer
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils/package-managers.sh"
source "${SCRIPT_DIR}/utils/os-detect.sh"

show_main_menu() {
    # Omitting TUI for this generated script. A real implementation would have one.
    log_info "Simulating selection of all components..."
    SELECTED_COMPONENTS=("mise" "languages" "javascript" "zsh" "editors" "fonts" "containers")
    return 0
}

main() {
    log "🚀 Starting dotfiles installation..."
    
    install_package_manager_deps "git" "curl" "zsh"

    # Symlink core configs
    ln -sf "${SCRIPT_DIR}/../configs/zsh/.zshrc" "$HOME/.zshrc"
    ln -sf "${SCRIPT_DIR}/../configs/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    mkdir -p "$HOME/.config/nvim"
    ln -sf "${SCRIPT_DIR}/../configs/nvim/init.lua" "$HOME/.config/nvim/init.lua"

    show_main_menu

    log_info "Installing components: ${SELECTED_COMPONENTS[*]}"
    for component in "${SELECTED_COMPONENTS[@]}"; do
        log_info "Installing ${component}..."
        case "$component" in
            mise)       bash "${SCRIPT_DIR}/modules/mise.sh" ;;
            languages)  bash "${SCRIPT_DIR}/modules/languages.sh" ;;
            javascript) bash "${SCRIPT_DIR}/modules/javascript.sh" ;;
            editors)    bash "${SCRIPT_DIR}/modules/editors.sh" ;;
            fonts)      bash "${SCRIPT_DIR}/../configs/fonts/install.sh" ;;
            containers) bash "${SCRIPT_DIR}/modules/containers.sh" ;;
            *) log_warning "Unknown component: $component" ;;
        esac
    done

    log_success "✅ Installation complete! Please restart your shell or run 'zsh'."
}

main "$@"
