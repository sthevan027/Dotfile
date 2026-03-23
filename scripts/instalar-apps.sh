#!/bin/bash
# Instala os apps da lista meus-apps.txt
# Rode: ./scripts/instalar-apps.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_FILE="$SCRIPT_DIR/../meus-apps.txt"

[ ! -f "$APPS_FILE" ] && echo "Arquivo $APPS_FILE não encontrado. Rode ./scripts/capturar-apps.sh primeiro." && exit 1

echo "Instalando apps de $APPS_FILE..."
echo ""

# APT
apt_pkgs=$(awk '/^=== APT ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
if [ -n "$apt_pkgs" ]; then
    echo ">>> Apt..."
    echo "$apt_pkgs" | xargs sudo apt install -y 2>/dev/null || true
fi

# Flatpak
flatpak_ids=$(awk '/^=== FLATPAK ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
if [ -n "$flatpak_ids" ] && command -v flatpak &>/dev/null; then
    echo ""
    echo ">>> Flatpak..."
    for id in $flatpak_ids; do
        flatpak install -y flathub "$id" 2>/dev/null || flatpak install -y "$id" 2>/dev/null || echo "  (pulando $id)"
    done
fi

# Snap
snap_pkgs=$(awk '/^=== SNAP ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
if [ -n "$snap_pkgs" ] && command -v snap &>/dev/null; then
    echo ""
    echo ">>> Snap..."
    for pkg in $snap_pkgs; do
        sudo snap install "$pkg" 2>/dev/null || echo "  (pulando $pkg)"
    done
fi

echo ""
echo "✓ Concluído!"
