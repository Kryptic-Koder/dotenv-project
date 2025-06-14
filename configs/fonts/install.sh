#!/usr/bin/env bash
# Nerd Fonts Installer
set -euo pipefail
log_info() { echo -e "\033[0;34m[fonts]\033[0m $*"; }
log_success() { echo -e "\033[0;32m✓\033[0m $*"; }

get_latest_release() {
  curl -s "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

install_nerd_fonts() {
    log_info "Installing Nerd Fonts (FiraCode, Meslo)..."
    local fonts_dir
    if [[ "$(uname)" == "Darwin" ]]; then fonts_dir="$HOME/Library/Fonts"; else fonts_dir="$HOME/.local/share/fonts"; fi
    mkdir -p "$fonts_dir"
    
    if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
        log_info "Downloading FiraCode Nerd Font..."
        local ver=$(get_latest_release "ryanoasis/nerd-fonts")
        curl -fLo "/tmp/FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/$ver/FiraCode.zip"
        unzip -o "/tmp/FiraCode.zip" -d "$fonts_dir"
        rm "/tmp/FiraCode.zip"
    fi
    
    if [ ! -f "$fonts_dir/MesloLGS NF Regular.ttf" ]; then
        log_info "Downloading MesloLGS NF..."
        for font in "MesloLGS%20NF%20Regular.ttf" "MesloLGS%20NF%20Bold.ttf" "MesloLGS%20NF%20Italic.ttf"; do
            curl -fLo "$fonts_dir/$(basename "$(printf '%b' "${font//%/\\x}")")" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
        done
    fi

    if command -v fc-cache >/dev/null; then fc-cache -f -v; fi
    log_success "Nerd Fonts installed. Please restart your terminal and set the font."
}
install_nerd_fonts
