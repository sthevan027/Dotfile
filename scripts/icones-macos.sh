#!/bin/bash
# Aplica ícones estilo macOS (WhiteSur)
# Rode: ./scripts/icones-macos.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "Instalando ícones WhiteSur (estilo macOS)..."

ICON_DIRS="/usr/share/icons $HOME/.icons $HOME/.local/share/icons"
WS_ICONS=""
for d in $ICON_DIRS; do
    [ -d "$d/WhiteSur" ] && WS_ICONS="yes" && break
done

if [ -z "$WS_ICONS" ]; then
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
    cd WhiteSur-icon-theme
    ./install.sh
    cd "$SCRIPT_DIR/.."
    rm -rf "$TMP_DIR"
fi

gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur'" 2>/dev/null || true

echo "✓ Ícones macOS aplicados!"
