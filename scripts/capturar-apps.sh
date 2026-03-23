#!/bin/bash
# Captura os apps instalados no Zorin e gera lista para reinstalação
# Rode: ./scripts/capturar-apps.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_FILE="$SCRIPT_DIR/../meus-apps.txt"

echo "Capturando apps instalados..."

{
    echo "# Apps instalados — $(date '+%Y-%m-%d')"
    echo "# Edite esta lista e rode ./scripts/instalar-apps.sh"
    echo ""
    echo "=== APT ==="
    apt-mark showmanual 2>/dev/null | sort | grep -vE '^(lib|linux-|grub|gnome-|gir1\.|fonts-|ca-|debconf|dpkg|adduser|base-|bash|cron|dbus|e2fsprogs|coreutils|findutils|grep|gzip|init|iproute2|kbd|kmod|less|locales)' | head -80
    echo ""
    echo "=== FLATPAK ==="
    flatpak list --app --columns=application 2>/dev/null | tail -n +1
    echo ""
    echo "=== SNAP ==="
    snap list 2>/dev/null | tail -n +2 | awk '{print $1}'
} > "$APPS_FILE"

echo "✓ Salvo em: $APPS_FILE"
echo ""
echo "Edite o arquivo para remover o que não quer, depois rode:"
echo "  ./scripts/instalar-apps.sh"
echo ""
