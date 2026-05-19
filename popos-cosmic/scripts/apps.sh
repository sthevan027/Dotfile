#!/usr/bin/env bash
# Apps Pop!_OS/COSMIC: capturar instalados → meus-apps.txt | instalar a partir do arquivo
# Uso: bash popos-cosmic/scripts/apps.sh capturar | instalar

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APPS_FILE="$REPO_ROOT/meus-apps.txt"

cmd="${1:-}"

capturar() {
  echo "Capturando apps instalados..."
  {
    echo "# Apps instalados — $(date '+%Y-%m-%d')"
    echo "# Edite e rode: bash popos-cosmic/scripts/apps.sh instalar"
    echo ""
    echo "=== APT ==="
    apt-mark showmanual 2>/dev/null | sort | grep -vE '^(lib|linux-|grub|gnome-|gir1\.|fonts-|ca-|debconf|dpkg|adduser|base-|bash|cron|dbus|e2fsprogs|coreutils|findutils|grep|gzip|init|iproute2|kbd|kmod|less|locales)'
    echo ""
    echo "=== FLATPAK ==="
    flatpak list --app --columns=application 2>/dev/null | tail -n +1
  } > "$APPS_FILE"
  echo "✓ Salvo em: $APPS_FILE"
}

instalar() {
  [ ! -f "$APPS_FILE" ] && echo "Arquivo $APPS_FILE não encontrado. Rode: bash popos-cosmic/scripts/apps.sh capturar" && exit 1

  echo "Instalando apps de $APPS_FILE..."
  echo ""

  apt_pkgs=$(awk '/^=== APT ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
  if [ -n "$apt_pkgs" ] && command -v apt &>/dev/null; then
    echo ">>> APT..."
    echo "$apt_pkgs" | xargs sudo apt install -y 2>/dev/null || true
  fi

  flatpak_ids=$(awk '/^=== FLATPAK ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
  if [ -n "$flatpak_ids" ] && command -v flatpak &>/dev/null; then
    echo ""
    echo ">>> Flatpak..."
    for id in $flatpak_ids; do
      flatpak install -y flathub "$id" 2>/dev/null || flatpak install -y "$id" 2>/dev/null || echo "  (pulando $id)"
    done
  fi

  echo ""
  echo "✓ Concluído!"
}

case "$cmd" in
  capturar) capturar ;;
  instalar) instalar ;;
  *)
    echo "Uso: $0 capturar | instalar"
    exit 1
    ;;
esac
