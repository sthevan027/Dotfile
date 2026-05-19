#!/usr/bin/env bash
# Apps Fedora/GNOME: capturar instalados → meus-apps.txt | instalar a partir do arquivo
# Uso: bash fedora-gnome/scripts/apps.sh capturar | instalar

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APPS_FILE="$REPO_ROOT/meus-apps.txt"

cmd="${1:-}"

capturar() {
  echo "Capturando apps instalados..."
  {
    echo "# Apps instalados — $(date '+%Y-%m-%d')"
    echo "# Edite e rode: bash fedora-gnome/scripts/apps.sh instalar"
    echo ""
    echo "=== DNF ==="
    dnf repoquery --userinstalled -q 2>/dev/null | sort
    echo ""
    echo "=== FLATPAK ==="
    flatpak list --app --columns=application 2>/dev/null | tail -n +1
  } > "$APPS_FILE"
  echo "✓ Salvo em: $APPS_FILE"
}

instalar() {
  [ ! -f "$APPS_FILE" ] && echo "Arquivo $APPS_FILE não encontrado. Rode: bash fedora-gnome/scripts/apps.sh capturar" && exit 1

  echo "Instalando apps de $APPS_FILE..."
  echo ""

  dnf_pkgs=$(awk '/^=== DNF ===$/{f=1;next} /^=== /{f=0} f&&!/^#/&&!/^$/' "$APPS_FILE")
  if [ -n "$dnf_pkgs" ] && command -v dnf &>/dev/null; then
    echo ">>> DNF..."
    echo "$dnf_pkgs" | xargs sudo dnf install -y 2>/dev/null || true
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
